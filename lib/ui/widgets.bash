#!/bin/bash
# -*- mode: sh -*-

yn() {
    local ret=$?
    # print the results from a previous command, or...
    if (( $# > 0 )) ; then
        # ...run a given command and save it's results
        local cmd="$1" ; shift
        $cmd "$@"
        ret=$?
    fi

    #tput el1
    col=$(tput cols)
    (( col = col - 5 ))
    tput cuf $col
    tput cuu1

    if (( ret == 0 )) ; then
        echo -en "$(pcolor bold:WHITE/green '<')"
        echo -en "$(pcolor bold:GREEN 'YES')"
        echo -e  "$(pcolor bold:WHITE/green '>')"
    else
        # length must match 'YES' !!!
        echo -en " $(pcolor bold:WHITE/red '*')"
        echo -en "$(pcolor bold:YELLOW/red 'NO')"
        echo -e  "$(pcolor bold:WHITE/red '*')"
    fi
    return $ret
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

# draw a TERM-wide horizontal line
L() {
    l=`builtin printf %${2:-$COLUMNS}s` && echo -e "${l// /${1:-=}}"
}

# redunden?
lin() {
    local L2 L1='__________________________________________________________________________'
    case ${1:-1} in
        0) echo -e "\n ${CC[0]}${L1}" ;;
        1) L2=`echo '                                                                          '`;echo -e "${CC[0]}|${CC[15]}${L2}${CC[0]}|" ;;
        2) echo -en "${CC[0]}|${CC[15]}"; echo -en "${2:-1}" | sed -e :a -e 's/^.\{1,72\}$/ & /;ta' -e "s/\(.*\)/\1/";   echo -e "${CC[0]} |" ;;
        3) echo -e "${CC[0]} ${L1} $R$X\n\n" ;;
    esac;
}

printbox() {
    lin 0
    lin 1
    lin 2 "$1"
    lin 1
    lin 3
}

####################################################
# Call spin() each iteration to update a spiner, and
# cleanup with endspin() afterwords

__sp="/-\|"
__sc=0
spin() {
   printf "\b${__sp:__sc++:1}"
   ((sc==${#__sp})) && __sc=0
}

endspin() {
   printf "\r%s\n" "$@"
}

sleeper() {
  [[ "$#" -lt "1" ]] && echo "Usage: $FUNCNAME <process id>" >&2 && return 2
  echo -en "\n${2:-.}"; while `command ps -p $1 &>$N6`; do echo -n "${2:-.}"; sleep ${3:-1}; done; echo;
}


countdown() {
    local OLD_IFS="${IFS}"
    IFS=":"
    local ARR=( $1 )
    local SECONDS=$((  (ARR[0] * 60 * 60) + (ARR[1] * 60) + ARR[2]  ))
    local START=$(date +%s)
    local END=$((START + SECONDS))
    local CUR=$START

    while [[ $CUR -lt $END ]] ; do
        CUR=$(date +%s)
        LEFT=$((END-CUR))

        printf "\r%02d:%02d:%02d" \
            $((LEFT/3600)) $(( (LEFT/60)%60)) $((LEFT%60))

        sleep 1
    done
    IFS="${OLD_IFS}"
    echo "        "
}


choose_single_file() {
    local title="${CHOOSE_FILE_TITLE:-Choose - Single File}"
    local icon="${CHOOSE_FILE_ICON:-unknown}"
    yad --title="$title" --list --separator='' --window-icon="$icon" --image="$icon" --filter="$filter" --column 'File' "$@"
}

choose_recent_local_file() {
    choose_single_file $(ls -t $@)
}
