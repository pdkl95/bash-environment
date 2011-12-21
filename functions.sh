#! /bin/bash
# -*- mode: sh -*-

load_sh 'functions/widget'
load_sh 'functions/queryhelper'
load_sh 'functions/emacs'
load_sh 'functions/run'
load_sh 'functions/proc'


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


function aa_isalpha ()
{
  [[ "$#" -lt "1" ]] && echo "Usage: $FUNCNAME str" >&2 && return 2
  case $1 in *[!a-zA-Z]*|"") return -1; ;; *) return 0; ;; esac;
}

function aa_isdigit ()
{
  case $1 in *[!0-9]*|"") return -1; ;; *) return 0; ;; esac;
}


parse_git_dirty() {
    [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit (working directory clean)" ]] && echo "*"
}

parse_git_branch() {
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/[\1$(parse_git_dirty)]/"
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

yes_no() {
    [[ "$#" -lt "1" ]] && echoerr "Usage: $FUNCNAME Question" && return 2
    local a YN=65
    echo -en "${1:-Answer} [Y/n] ?"
    read -n 1 a
    case $a in
        [yY]) YN=0 ;;
    esac
    return $YN
}

yn() {
    [[ "$#" -lt "1" ]] && echo "Usage: $FUNCNAME " >yn && return 2
    local a YN=65
    echo -en "\n ${CC[6]}@@ ${1:-Q} $R$X[y/N] ?$R"
    read -n 1 a
    echo
    case $a in
        [yY])
            echo -n "Y"
            YN=0
            ;;
        *)
            echo -n "N"
    esac
    return $YN;
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

# possible addition to the above... needs work first :/
# atb() {
#    l=$(tar tf $1)
#     if [ $(echo "$l" | wc -l) -eq $(echo "$l" | grep $(echo "$l" | head -n1) | wc -l) ]; then
#         tar xvf $1
#     else
#         mkdir ${1%.t@(ar.gz|ar.bz2|gz|bz|ar)} && tar xvf $1 -C ${1%.t@(ar.gz|ar.bz2|gz|bz|ar)}
#     fi
# }



# Repeat n times command.
repeat() {
    local i max
    max=$1
    shift
    for ((i=1; i <= max ; i++)); do
        eval "$@"
    done
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

mplayer_ident() {
     mplayer2 -msglevel all=0 -identify -frames 0 "$@"  2> /dev/null
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


vacuum_firefox() {
    find ~/.mozilla/firefox/ -type f -name "*.sqlite" -exec sqlite3 {} VACUUM \;
}

#nuke_site() {
#    local host="$1"
#    firefox -new-tab "http://meyerweb.com/eric/tools/gmap/hydesim.html?dll=$(GET "$host" | grep ICBM | sed -e "s/<meta content='//" -e "s/'.*//" -e 's/ //')&yd=22&zm=12&op=156"
#}


my_ip_from_outsie_prespective() {
    curl ifconfig.me
}
