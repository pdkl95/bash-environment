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
