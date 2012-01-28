#!/bin/bash

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

ANSI_COLOR_LIST="bk rd gr yl bl pr cy wh"
ANSI_MODE_LIST_COMMON="N D B"
ANSI_MODE_LIST="${ANSI_MODE_LIST_COMMON} U R"
ANSI_MODE_LIST_FULL="${ANSI_MODE_LIST} I C"

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
            c|C|cn|CN|concealed|CONCEALED)     echo -ne '\e[8m' ;;
            r|R|rv|RV|reverse|REVERSE)         echo -ne '\e[7m' ;;
            i|I|bi|BI|blink|BLINK)             echo -ne '\e[5m' ;;
            u|U|ul|UL|underline|UNDERLINE)           echo -ne '\e[4m' ;;
            d|D|di|DI|dark|DARK|dim|DIM)       echo -ne '\e[2m' ;;
            b|B|bd|bd|bold|BOLD)               echo -ne '\e[1m' ;;
            n|N|nr|NR|clear|CLEAR|reset|RESET) echo -ne '\e[0m' ;;
            *)                             echo -ne '\e[0m' ;;
        esac
    }

    color_name_to_ansi_fg() {
        case "$1" in
            bk|black)   echo -ne '\e[30m' ;;
            rd|red)     echo -ne '\e[31m' ;;
            gr|green)   echo -ne '\e[32m' ;;
            yl|yellow)  echo -ne '\e[33m' ;;
            bl|blue)    echo -ne '\e[34m' ;;
            pr|purple)  echo -ne '\e[35m' ;;
            mg|magenta) echo -ne '\e[35m' ;;
            cy|cyan)    echo -ne '\e[36m' ;;
            wh|white)   echo -ne '\e[37m' ;;
            BK|BLACK)   echo -ne '\e[90m' ;;
            RD|RED)     echo -ne '\e[91m' ;;
            GR|GREEN)   echo -ne '\e[92m' ;;
            YL|YELLOW)  echo -ne '\e[93m' ;;
            BL|BLUE)    echo -ne '\e[94m' ;;
            PR|PURPLE)  echo -ne '\e[95m' ;;
            MG|MAGENTA) echo -ne '\e[95m' ;;
            CY|CYAN)    echo -ne '\e[96m' ;;
            WH|WHITE)   echo -ne '\e[97m' ;;
        esac
    }

    color_name_to_ansi_bg() {
        case "$1" in
            bk|black)   echo -ne '\e[40m' ;;
            rd|red)     echo -ne '\e[41m' ;;
            gr|green)   echo -ne '\e[42m' ;;
            yl|yellow)  echo -ne '\e[43m' ;;
            bl|blue)    echo -ne '\e[44m' ;;
            pr|purple)  echo -ne '\e[45m' ;;
            mg|magenta) echo -ne '\e[45m' ;;
            cy|cyan)    echo -ne '\e[46m' ;;
            wh|white)   echo -ne '\e[47m' ;;
            BK|BLACK)   echo -ne '\e[100m' ;;
            RD|RED)     echo -ne '\e[101m' ;;
            GR|GREEN)   echo -ne '\e[102m' ;;
            YL|YELLOW)  echo -ne '\e[103m' ;;
            BL|BLUE)    echo -ne '\e[104m' ;;
            PR|PURPLE)  echo -ne '\e[105m' ;;
            MG|MAGENTA) echo -ne '\e[105m' ;;
            CY|CYAN)    echo -ne '\e[106m' ;;
            WH|WHITE)   echo -ne '\e[107m' ;;
        esac
    }

    color_name_to_ansi() {
        local X="$1"

        while [[ "$X" =~ ^(.*)[!:](.*)$ ]] ; do
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
        sed -r "s/\x1B\[([0-9]{1,3}((;[0-9]{1,3})*)?)?[m|K]//g"

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
    pcolor()                { echo -n "$@"; }
    strip_ansi()            { echo -n "$@"; }
fi

###############################################
# Color Helpers & Macros
#
# MUST be implemented *strictly* in terms of
# the overridable functions found above!!!!

pcolor_wrap() {
    local L="$1" R="$2" ; shift 2

    # optional FIRST color for the wrapper
    local Cwrap="purple"
    if [[ $# -gt 1 ]] ; then
        Cwrap="$1"; shift
    fi

    # optional SECOND color for the inner-text
    local TXT
    if [[ $# -gt 1 ]] ; then
        local C="$1" ; shift
        TXT="$(pcolor "$C" "$*")"
    else
        TXT="$*"
    fi
    echo -n "$(pcolor "$Cwrap" "$L")$TXT$(pcolor "$Cwrap" "$R")"
}

pcolor_wrap_paren()  { pcolor_wrap '(' ')' "$@" ; }
pcolor_wrap_square() { pcolor_wrap '[' ']' "$@" ; }
pcolor_wrap_angle()  { pcolor_wrap '<' '>' "$@" ; }
pcolor_wrap_curly()  { pcolor_wrap '{' '}' "$@" ; }


demo_ansi_colors() {
    local mlist mchr clist="" max colsperstack stackwidth stackmax stacklimit

    if [[ "$1" == "-c" ]] ; then
        mlist="${ANSI_MODE_LIST_COMMON}"
        shift
    elif [[ "$1" == "-f" ]] ; then
        mlist="${ANSI_MODE_LIST_FULL}"
        shift
    else
        mlist="${ANSI_MODE_LIST}"
    fi
    mchr="$(echo "$mlist" | tr -d ' ')"
    colsperstack=${#mchr}

    (( max=8 ))

    (( stackwidth=colsperstack*max ))
    (( stackmax=COLUMNS/stackwidth ))

    (( stacklimit=2*(stackmax/2) ))

    for c in ${ANSI_COLOR_LIST}; do
        clist="$clist $c $(upcase $c)"
    done

    for bg in $clist; do
        local stack=0
        for fg in $clist; do
            local line=""
            local linelen newlen
            (( linelen=0 ))
            for mode in $mlist; do
                local C="${mode}:${fg}/${bg}"
                local S="$C"
                local Slen="${#S}" Plen newlen
                (( Plen=max-Slen ))
                local P=$(printf "%${Plen}s")
                (( newlen=linelen+max ))
                if (( $newlen >= $COLUMNS )) ; then
                    echo "$line"
                    line=""
                    (( linelen=0 ))
                else
                    (( linelen=newlen ))
                fi
                line="${line}$(pcolor "$C" "$S$P")"
            done
            echo -ne "$line"
            (( linelen=0 ))
            (( stack++ ))
            if (( stack >= stacklimit )) ; then
                (( stack=0 ))
                echo
                #echo --
            fi
        done
        #echo "    <<< BG >>>   "
    done
}

######################
# "256 colors" style #
######################

_Cff() { tput setaf $1 ; }  # foreground
_Cbb() { tput setab $1 ; }  # background
_C00() { tput sgr0     ; }  # reset


# wrap text in a "256 colors" style color
Cwrap() {
    local code="$1" ; shift
    _Cff $code
    echo -ne "$*"
    _C00
}

# shorthand for changing to a color and echoing
# text WITHOUT the reset, to save time
C() {
    local code="$1" ; shift
    _Cff $code
    echo -ne "$*"
}


demo_256_colors() {
    local i j x y
    for i in {0..31}; do
        for j in {0..7}; do
            (( x=(32*j)+i ))
            (( y=255-x ))
            _Cff 0
            _Cbb $x
            echo -n ' X?'
            _C00
            echo -n ' '
            _Cff $x
            printf "%03d " $x
            _Cff $y
            _Cbb $x
            printf "%03d" $y
            _C00
            echo -n '   '
        done
        echo
    done
}

# Local Variables:
# mode: sh
# sh-basic-offset: 4
# sh-shell: bash
# coding: unix
# End:
