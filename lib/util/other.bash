#! /bin/bash
# -*- mode: sh -*-

###################
###  shortcuts  ###
###################

fullenv() {
    for _a in {A..Z} {a..z} ; do
        _z=\${!${_a}*}
        for _i in `eval echo "${_z}"` ; do
            echo -e "$_i: ${!_i}"
        done
    done | cat -Tsv
}

xtitle() {      # Adds some text in the terminal frame.
    local title="$(echo "$*" | strip_ansi_escape_codes)"
    case "$TERM" in
        *term|rxvt)  echo -ne "\033]0;${title}\007" ;;
        *)           echo -ne "" ;;
    esac
}

ask_yn() {
    if (( $# < 1 )) ; then
        echo "Usage: $FUNCNAME <question>"
        return 2
    fi
    local a
    echo -en "$(pcolor PURPLE "${1:-Q}") "
    echo -en "$(pcolor_wrap_square BLUE $(pcolor GREEN 'y')$(pcolor blue '/')$(pcolor RED 'N'))"
    echo -en "? "
    read -n 1 -s a
    case $a in
        [yY]) echo "$(pcolor DIM:GREEN/BLACK 'YES')" ; return 0 ;;
        *)    echo "$(pcolor black/red   'NO')"  ; return 1 ;;
    esac
}

# all man pages!
man() {
    for i ; do
        xtitle man -a $(basename $1|tr -d .[:digit:])
        command man -a "$i"
    done
}

# draw a TERM-wide horizontal line
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

my_ip_from_outsie_prespective() {
    curl ifconfig.me
}
alias my_ip="my_ip_from_outside_prespective"

mplayer_ident() {
     mplayer2 -msglevel all=0 -identify -frames 0 "$@"  2> /dev/null
}

di.fm() {
    zenity --list --width 500 --height 500 --column 'radio' --column 'url' --print-column 2 $(curl -s http://www.di.fm/ | awk -F '"' '/href="http:.*\.pls.*96k/ {print $2}' | sort | awk -F '/|\.' '{print $(NF-1) " " $0}') | xargs mplayer
}

#ytplay() {
#    mplayer -fs -quiet $(youtube-dl -g "$1")
#}

#mplayerfb() {
#    mplayer -vo fbdev $1 -fs -subcp ${2:-cp1251} -vf scale=${3:-1280:720}
#}

if is_cmd sqlite3 ; then
    sqlite_cleanup() {
        if [[ -w "$1" ]] ; then
            sqlite3 "$1" VACUUM
            sqlite3 "$1" REINDEX
        fi
    }

    vacuum_firefox() {
        for db in "$HOME"/.mozilla/firefox/????????.*/*.sqlite ; do
            echo "VACUUMING: ${db}"
            sqlite_cleanup "$db"
        done
    }
fi


#nuke_site() {
#    local host="$1"
#    firefox -new-tab "http://meyerweb.com/eric/tools/gmap/hydesim.html?dll=$(GET "$host" | grep ICBM | sed -e "s/<meta content='//" -e "s/'.*//" -e 's/ //')&yd=22&zm=12&op=156"
#}


colorize() {
    local lang="${1:-cl}"
    local mode="terminal256"

#    local style="friendly"
#    local style="railscasts"
    local style="twilight"

    pygmentize -f $mode -l $lang -O style=$style -F tokenmerge
}
