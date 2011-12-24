############################
###  ANSI COLOR HELPERS  ###
############################
# enable color if possilbe

if is_defined USE_ANSI_COLOR ; then
    if [[ ${USE_ANSI_COLOR} == 0 ]] || [[ "${USE_ANSI_COLOR}" == "true" ]] ; then
        USE_ANSI_COLOR=true
    else
        USE_ANSI_COLOR=false
    fi
else
    case ${TERM:-dummy} in
        linux*|con80*|con132*|console|xterm*|vt*|screen*|putty|Eterm|dtterm|ansi|rxvt|gnome*|*color*)
            : ${USE_ANSI_COLOR:=true}   ;;
        *)  : ${USE_ANSI_COLOR:=false}  ;;
    esac
fi

# Defne the base color values and helpers
# iff color is enabled. otherwise, pass things
# though unchanged with empty-strings
if $USE_ANSI_COLOR ; then
    AUTOCOLOR=' --color=auto'

    # Reset
    CCnil='\e[0m'             # Text Reset

    # Regular Colors
    CCblack='\e[0;30m'        # Black
    CCred='\e[0;31m'          # Red
    CCgreen='\e[0;32m'        # Green
    CCyellow='\e[0;33m'       # Yellow
    CCblue='\e[0;34m'         # Blue
    CCpurple='\e[0;35m'       # Purple
    CCcyan='\e[0;36m'         # Cyan
    CCwhite='\e[0;37m'        # White

    # Bold
    CCBblack='\e[1;30m'       # Black
    CCBred='\e[1;31m'         # Red
    CCBgreen='\e[1;32m'       # Green
    CCByellow='\e[1;33m'      # Yellow
    CCBblue='\e[1;34m'        # Blue
    CCBpurple='\e[1;35m'      # Purple
    CCBcyan='\e[1;36m'        # Cyan
    CCBwhite='\e[1;37m'       # White

    # Underline
    CCUblack='\e[4;30m'       # Black
    CCUred='\e[4;31m'         # Red
    CCUgreen='\e[4;32m'       # Green
    CCUyellow='\e[4;33m'      # Yellow
    CCUblue='\e[4;34m'        # Blue
    CCUpurple='\e[4;35m'      # Purple
    CCUcyan='\e[4;36m'        # Cyan
    CCUwhite='\e[4;37m'       # White

    # Background
    CCon_black='\e[40m'       # Black
    CCon_red='\e[41m'         # Red
    CCon_green='\e[42m'       # Green
    CCon_yellow='\e[43m'      # Yellow
    CCon_blue='\e[44m'        # Blue
    CCon_purple='\e[45m'      # Purp/le
    CCon_cyan='\e[46m'        # Cyan
    CCon_white='\e[47m'       # White

    # High Intensty
    CCIblack='\e[0;90m'       # Black
    CCIred='\e[0;91m'         # Red
    CCIgreen='\e[0;92m'       # Green
    CCIyellow='\e[0;93m'      # Yellow
    CCIblue='\e[0;94m'        # Blue
    CCIpurple='\e[0;95m'      # Purple
    CCIcyan='\e[0;96m'        # Cyan
    CCIwhite='\e[0;97m'       # White

    # Bold High Intensty
    CCBIblack='\e[1;90m'      # Black
    CCBIred='\e[1;91m'        # Red
    CCBIgreen='\e[1;92m'      # Green
    CCBIyellow='\e[1;93m'     # Yellow
    CCBIblue='\e[1;94m'       # Blue
    CCBIpurple='\e[1;95m'     # Purple
    CCBIcyan='\e[1;96m'       # Cyan
    CCBIwhite='\e[1;97m'      # White

    # High Intensty backgrounds
    CCon_Iblack='\e[0;100m'   # Black
    CCon_Ired='\e[0;101m'     # Red
    CCon_Igreen='\e[0;102m'   # Green
    CCon_Iyellow='\e[0;103m'  # Yellow
    CCon_Iblue='\e[0;104m'    # Blue
    CCon_Ipurple='\e[10;95m'  # Purple
    CCon_Icyan='\e[0;106m'    # Cyan
    CCon_Iwhite='\e[0;107m'   # White

    attr_name_to_ansi() {
        case "$1" in
            concealed|CONCEALED)     echo -ne '\e[8m' ;;
            reverse|REVERSE)         echo -ne '\e[7m' ;;
            blink|BLINK)             echo -ne '\e[5m' ;;
            underline|UNDERLINE)     echo -ne '\e[4m' ;;
            dark|DARK|faint|FAINT)   echo -ne '\e[2m' ;;
            bold|BOLD)               echo -ne '\e[1m' ;;
            clear|CLEAR|reset|RESET) echo -ne '\e[0m' ;;
            *)                       echo -ne '\e[0m' ;;
        esac
    }

    color_name_to_ansi_fg() {
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

    pcolor() {
        local C="$1" ; shift
        echo -n $(color_name_to_ansi "$C")"$@"$'\e[0m'
    }

    strip_ansi_escape_codes() {
        sed -r "s/(\x5C\x5B)?\x1B\[([0-9]{1,3}((;[0-9]{1,3})*)?)?[m|K](\x5C\x5D)?//g"
    }
else
    # COLOR IS OFF, define things to their respectve null/emptry
    # values or otherwise pass things through unchanged
    AUTOCOLOR=''
    CCnil=''
    for x in CC{,B,U,I,on_,BI,on_I}{black,red,green,yellow,blue,purple,cyan,white} ; do
        declare -- "$x"=""
    done

    unset -f pcolor color_name_to_ansi{,_bg,_fg} attr_name_to_ansi
    attr_name_to_ansi()     { echo -n ''; }
    color_name_to_ansi_fg() { echo -n ''; }
    color_name_to_ansi_bg() { echo -n ''; }
    color_name_to_ansi()    { echo -n ''; }
    pcolor()     { echo -n "$@"; }
    strip_ansi() { echo -n "$@"; }
fi
