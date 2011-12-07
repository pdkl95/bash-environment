#! /bin/bash
# -*- mode: sh -*-

###############################
###  general utils/helpers  ###
###############################

fullenv() {
    for _a in {A..Z} {a..z} ; do
        _z=\${!${_a}*}
        for _i in `eval echo "${_z}"` ; do
            echo -e "$_i: ${!_i}"
        done
    done | cat -Tsv
}

path() {
    echo -e "${PATH//:/\n}"
}

parse_git_dirty() {
    [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit (working directory clean)" ]] && echo "*"
}

parse_git_branch() {
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/[\1$(parse_git_dirty)]/"
}

emacsclient() {
    command emacsclient --create-frame --no-wait --alternate-editor="/usr/bin/emacs" "$@"
}

e() {
  emacsclient "$@" >& /dev/null &disown
}

strip_ansi_escape_codes() {
    sed -r "s/(\x5C\x5B)?\x1B\[([0-9]{1,3}((;[0-9]{1,3})*)?)?[m|K](\x5C\x5D)?//g"
}

xtitle() {      # Adds some text in the terminal frame.
    local title="$(echo "$*" | strip_ansi_escape_codes)"
    case "$TERM" in
        *term|rxvt)  echo -ne "\033]0;${title}\007" ;;
        *)           echo -ne "" ;;
    esac
}

man() {
    for i ; do
        xtitle man -a $(basename $1|tr -d .[:digit:])
        command man -a "$i"
    done
}

L() {
    l=`builtin printf %${2:-$COLUMNS}s` && echo -e "${l// /${1:-=}}"
}

bad_symlinks() {
    ARG="$@"
    [[ -n $ARG ]] || ARG="$PWD"

    find -L "$ARG" -type l
}

# Swap 2 filenames around, if they exist
swap() {
    local TMPFILE=tmp.$$

    [ $# -ne 2 ] && echo "swap: 2 arguments needed" && return 1
    [  ! -e $1 ] && echo "swap: $1 does not exist"  && return 1
    [  ! -e $2 ] && echo "swap: $2 does not exist"  && return 1

    mv "$1" $TMPFILE
    mv "$2" "$1"
    mv $TMPFILE "$2"
}


extract() {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xvjf $1     ;;
            *.tar.gz)    tar xvzf $1     ;;
            *.bz2)       bunzip2 $1      ;;
            *.rar)       unrar x $1      ;;
            *.gz)        gunzip $1       ;;
            *.tar)       tar xvf $1      ;;
            *.tbz2)      tar xvjf $1     ;;
            *.tgz)       tar xvzf $1     ;;
            *.zip)       unzip $1        ;;
            *.Z)         uncompress $1   ;;
            *.7z)        7z x $1         ;;
            *)           echo "'$1' cannot be extracted via >extract<" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# possible addition to the above... needs work first :/
# atb() {
#    l=$(tar tf $1)
#     if [ $(echo "$l" | wc -l) -eq $(echo "$l" | grep $(echo "$l" | head -n1) | wc -l) ]; then
#         tar xvf $1
#     else
#         mkdir ${1%.t@(ar.gz|ar.bz2|gz|bz|ar)} && tar xvf $1 -C ${1%.t@(ar.gz|ar.bz2|gz|bz|ar)}
#     fi
# }

cps() {
    ps -u root U `whoami` --forest -o pid,stat,tty,user,command |ccze -m ansi
}

my_ps() {
    ps --deselect --ppid 2 "$@" -o pid,user,%cpu,%mem,nlwp,stat,bsdstart,vsz,rss,cmd --sort=bsdstart
}

my_ps_tree() {
    ps_custom f "$@"
}

my_ps_tree_wide() {
    my_ps_tree ww
}

# Repeat n times command.
repeat() {
    local i max
    max=$1; shift;
    for ((i=1; i <= max ; i++)); do  # --> C-like syntax
        eval "$@";
    done
}


# See 'killps' for example of use.
ask() {
    echo -n "$@" '[y/n] ' ; read ans
    case "$ans" in
        y*|Y*) return 0 ;;
        *)     return 1 ;;
    esac
}

dircmp() {
    diff -qrsl $1 $2 | sort -r | \
        awk '/differ/ {
           print "different  ",$2;
         }
         /are identical/ {
           print "same       ",$2;
         }
         /Only in/ {
           print $0;
         }'
}

byteMe() {
    # Divides by 2^10 until < 1024 and then append metric suffix

    # Array of suffixes
    declare -a METRIC=('B' 'KB' 'MB' 'GB' 'TB' 'XB' 'PB')

    # magnitude of 2^10
    MAGNITUDE=0

    # change this numeric value to inrease decimal precision
    PRECISION="scale=1"
    # numeric arg val (in bytes) to be converted
    UNITS=`echo $1 | tr -d ‘,’`

    # compares integers (b/c no floats in bash)
    while [ ${UNITS/.*} -ge 1024 ]
    do
        # floating point math via `bc`
        UNITS=`echo "$PRECISION; $UNITS/1024" | bc`

        # increments counter for array pointer
        ((MAGNITUDE++))
    done
    echo "$UNITS${METRIC[$MAGNITUDE]}"
}

fix_tree_fmt() {
    while read line ; do
        local -a a=(`echo ${line/ / }`)
        local    h=$(byteMe "$a")
        unset a[0]

        while [ $#h -lt 7 ] ; do
            h=" ${a}"
        done
        echo $h ${a[*]}
    done
}

fmt_tree() {
    fix_tree_fmt | tr ' ' "\t" | column -t
}

reorder_tree() {
    sort "$@"
}

declare LTREE_FINDOPTS LTREE_TIMEFMT
LTREE_TIMEFMT="%Tb-%Td,%TH:%TM"
list_tree_data() {
    local COL1="$1"
    shift
    [[ -n "${LTREE_FINDOPTS}" ]] || LTREE_FIND_OPTS="-type f"

    find "$@" "${LTREE_FINDOPTS}" -printf "${COL1} %s %M %u ${LTREE_TIMEFMT} %p\n"
}

list_sorted_tree() {
    local COL1="$1" SORTOPT="$2"
    shift 2
    list_tree_data "$COL1" "$@" | reorder_tree "${SORTOPT}" | fmt_tree
}

list_globbed_tree() {
    local PREVOPT="${LTREE_FINDOPT}" GLOB="$1"
    shift
    LTREE_FINDOPTS="${PREVOPT} -iname ${GLOB}"
    list_sorted_tree "%P"  '-i'    "$@"
    LTREE_FINDOPTS="${PREVOPT}"
}
list_tree_mtime_asc() {
    list_sorted_tree '%T@' '-n'    "$@"
}
list_tree_mtime_desc() {
    list_sorted_tree '%T@' '-n -r' "$@"
}
list_tree_size_asc() {
    list_sorted_tree '%s'  '-n'    "$@"
}
list_tree_size_desc() {
    list_sorted_tree '%s'  '-n -r' "$@"
}

di.fm() {
    zenity --list --width 500 --height 500 --column 'radio' --column 'url' --print-column 2 $(curl -s http://www.di.fm/ | awk -F '"' '/href="http:.*\.pls.*96k/ {print $2}' | sort | awk -F '/|\.' '{print $(NF-1) " " $0}') | xargs mplayer
}

ytplay() {
    mplayer -fs -quiet $(youtube-dl -g "$1")
}

mplayerfb() {
    mplayer -vo fbdev $1 -fs -subcp ${2:-cp1251} -vf scale=${3:-1280:720}
}

list_open_ports() {
    sudo lsof -Pi | grep LISTEN
}


vacuum_firefox() {
    find ~/.mozilla/firefox/ -type f -name "*.sqlite" -exec sqlite3 {} VACUUM \;
}
