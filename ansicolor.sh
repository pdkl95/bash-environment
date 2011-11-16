############################
###  ANSI COLOR HELPERS  ###
############################

function attr_name_to_ansi {
    case "$1" in
    concealed|CONCEALED)     echo -ne '\e[8m' ;;
    reverse|REVERSE)         echo -ne '\e[7m' ;;
    blink|BLINK)             echo -ne '\e[5m' ;;
    underline|UNDERLINE)     echo -ne '\e[4m' ;;
    dark|DARK|faint|FAINT)   echo -ne '\e[2m' ;;
    bold|BOLD)               echo -ne '\e[1m' ;;
    clear|CLEAR|reset|RESET) echo -ne '\e[0m' ;;
    *)                       echo -ne '\e[0m' ;;  # clear on error
    esac
}

function color_name_to_ansi_fg {
    case "$1" in
    black)  echo -ne '\e[30m' ;;
    red)    echo -ne '\e[31m' ;;
    green)  echo -ne '\e[32m' ;;
    yellow) echo -ne '\e[33m' ;;
    blue)   echo -ne '\e[34m' ;;
    purple) echo -ne '\e[35m' ;;
    cyan)   echo -ne '\e[36m' ;;
    white)  echo -ne '\e[37m' ;;
    BLACK)  echo -ne '\e[90m' ;;
    RED)    echo -ne '\e[91m' ;;
    GREEN)  echo -ne '\e[92m' ;;
    YELLOW) echo -ne '\e[93m' ;;
    BLUE)   echo -ne '\e[94m' ;;
    PURPLE) echo -ne '\e[95m' ;;
    CYAN)   echo -ne '\e[96m' ;;
    WHITE)  echo -ne '\e[97m' ;;
    esac
}

function color_name_to_ansi_bg {
    case "$1" in
    black)  echo -ne '\e[40m' ;;
    red)    echo -ne '\e[41m' ;;
    green)  echo -ne '\e[42m' ;;
    yellow) echo -ne '\e[43m' ;;
    blue)   echo -ne '\e[44m' ;;
    purple) echo -ne '\e[45m' ;;
    cyan)   echo -ne '\e[46m' ;;
    white)  echo -ne '\e[47m' ;;
    BLACK)  echo -ne '\e[100m' ;;
    RED)    echo -ne '\e[101m' ;;
    GREEN)  echo -ne '\e[102m' ;;
    YELLOW) echo -ne '\e[103m' ;;
    BLUE)   echo -ne '\e[104m' ;;
    PURPLE) echo -ne '\e[105m' ;;
    CYAN)   echo -ne '\e[106m' ;;
    WHITE)  echo -ne '\e[107m' ;;
    esac
}

function color_name_to_ansi {
    local X="$1"

    while [[ "$X" =~ ^(.*)!(.*)$ ]] ; do
        X=${BASH_REMATCH[2]}
        attr_name_to_ansi ${BASH_REMATCH[1]}
    done

    if [[ "$X" =~ ^/(.*)$ ]] ; then
        color_name_to_ansi_bg ${BASH_REMATCH[1]}
    elif [[ "$X" =~ ^(.*)/(.*)$ ]] ; then
        color_name_to_ansi_fg ${BASH_REMATCH[1]}  #${1%%/*}
        color_name_to_ansi_bg ${BASH_REMATCH[2]}  #${1##*/}
    else
        color_name_to_ansi_fg $X
    fi
}

function pcolor {
    local C="$1" ; shift
    echo -n $(color_name_to_ansi "$C")"$@"$'\e[0m'
}

export NC="\[\033[0m\]"
export red="\[\033[0;31m\]"
export RED='\[\033[1;31m\]'
export green='\[\033[0;32m\]'
export GREEN='\[\033[1;32m\]'
export yellow='\[\033[0;33m\]'
export YELLOW='\[\033[1;33m\]'
export blue='\[\033[0;34m\]'
export BLUE='\[\033[1;34m\]'
export purple='\[\033[0;35m\]'
export PURPLE='\[\033[1;35m\]'
export cyan='\[\033[0;36m\]'
export CYAN='\[\033[1;36m\]'
export white='\[\033[0;37m\]'
export WHITE='\[\033[1;37m\]'

if [ $USE_ANSI_COLOR -eq 0 ] ; then
    unset -f attr_name_to_ansi
    function attr_name_to_ansi {
        echo -n ''
    }
    unset -f color_name_to_ansi_fg
    function color_name_to_ansi_fg {
        echo -n ''
    }
    unset -f color_name_to_ansi_bg
    function color_name_to_ansi_bg {
        echo -n ''
    }
    unset -f color_name_to_ansi
    function color_name_to_ansi {
        echo -n ''
    }
    unset -f pcolor
    function pcolor {
        echo -n "$@"
    }

    export NC=''
    export red=''
    export RED=''
    export green=''
    export GREEN=''
    export yellow=''
    export YELLOW=''
    export blue=''
    export BLUE=''
    export purple=''
    export PURPLE=''
    export cyan=''
    export CYAN=''
    export white=''
    export WHITE=''
fi

function pcolorln {
    pcolor "$@"
    echo
}

function NC {
    color_name_to_ansi 'clear'
}

STRONG_MARKER_L="$(pcolor DARK!red '-')$(pcolor red '=')$(pcolor BOLD!red '<')"
STRONG_MARKER_R="$(pcolor BOLD!red '>')$(pcolor red '=')$(pcolor DARK!red '-')"
function strong_msg {
    echo "${STRONG_MARKER_L}$(pcolor BOLD!green ' '${1}' ')${STRONG_MARKER_R}"
}

function warn_msg {
    strong_msg "$(pcolor YELLOW 'WARNING:') $@"
}

function error_msg {
    strong_msg "$(pcolor RED 'ERROR:') $@"
}

BLANK_LINE="$(pcolor BLACK '')"
function blankln {
    # force some useless ANSI in, so it doesn't get eaten by bash
    echo "$BLANK_LINE"
}
