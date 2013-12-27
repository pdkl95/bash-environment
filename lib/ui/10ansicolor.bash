#!/bin/bash

############################
###  ANSI COLOR HELPERS  ###
# enable color if possilbe

# Defne the base color values and helpers
# iff color is enabled. otherwise, pass things
# though unchanged with empty-strings
if [[ "${TERM}" =~ color ]] ; then
    AUTOCOLOR='--color=auto'

    attr_name_to_ansi() {
        case "$1" in
            c|C|cn|CN|concealed|CONCEALED)     echo -ne '\e[8m' ;;
            r|R|rv|RV|reverse|REVERSE)         echo -ne '\e[7m' ;;
            i|I|bi|BI|blink|BLINK)             echo -ne '\e[5m' ;;
            u|U|ul|UL|underline|UNDERLINE)     echo -ne '\e[4m' ;;
            d|D|di|DI|dark|DARK|dim|DIM)       echo -ne '\e[2m' ;;
            b|B|bd|bd|bold|BOLD)               echo -ne '\e[1m' ;;
            n|N|nr|NR|clear|CLEAR|reset|RESET) echo -ne '\e[0m' ;;
            *)                                 echo -ne '\e[0m' ;;
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

    strip_ansi() {
        sed -r "s/\x1B\[([0-9]{1,3}((;[0-9]{1,3})*)?)?[m|K]//g"

    }

    # ok, not a color, but it does use ANSI codes

    if   [[ "$TERM" =~ rxvt-unicode.* ]] ; then
        _xtitle() {
             local title="${xtitlePFX}$(echo "$*" | strip_ansi)"
             printf '\33]2;%s\007' "${title}"
        }
    elif [[ "$TERM" =~ (xterm|rxvt|rxvt-unicode|gnome)-(256)?color ]] ; then
        _xtitle() {
            local title="${xtitlePFX}$(echo "$*" | strip_ansi)"
            echo -ne "\033]0;${title}\007"
        }
    elif [[ "$TERM" =~ screen.* ]] ; then
        _xtitle() {
            local title="${xtitlePFX}$(echo "$*" | strip_ansi)"
            echo -ne "\e]2;${title}\007"
        }
    else
        _xtitle() {
            echo -n ''
        }
    fi
else
    # COLOR IS OFF, define things to their respectve null/emptry
    # values or otherwise pass things through unchanged
    AUTOCOLOR=''

    unset -f pcolor color_name_to_ansi{,_bg,_fg} attr_name_to_ansi
    attr_name_to_ansi()     { echo -n ''; }
    color_name_to_ansi_fg() { echo -n ''; }
    color_name_to_ansi_bg() { echo -n ''; }
    color_name_to_ansi()    { echo -n ''; }
    pcolor()                { echo -n "$@"; }
    strip_ansi()            { echo -n "$@"; }
    _xtitle()                { echo -n ''; }
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


######################
# "256 colors" style #
######################

if [[ "${TERM}" =~ 256color ]] ; then
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

else
    _Cff()  { : ; }
    _Cbb()  { : ; }
    _C00()  { : ; }
    Cwrap() { shift ; echo -ne "$*" ; }
    C()     { shift ; echo -ne "$*" ; }
fi


#########################
# set the xterm's title #
#########################

xtitle() {
    local -a title=() args=()
    local after_mark=false cmd=
    
    while (( $# > 0 )) ; do
        if $after_mark ; then
            args+=( "$1" )
        else
            if [[ "$1" == '--' ]] ; then
                after_mark=true
                shift
                cmd="$1"
            else
                title+=( "$1" )
            fi
        fi
        shift
    done

    if $after_mark && [[ -n "${cmd}" ]] ; then
        _xtitle "${title[*]}" && "${cmd}" "${args[@]}"
    else
        _xtitle "${title[*]}"
    fi
}

xtitle_cmd_on_host() {
    local showcmd= cmd="$1" ; shift
    case "${cmd}" in
        sudo) showcmd="$1" ;;
        *)    showcmd="${cmd}" ;;
    esac
    xtitle "${showcmd}: $(hostname -f)" -- "${cmd}" "$@"
}


# Local Variables:
# mode: sh
# sh-basic-offset: 4
# sh-shell: bash
# coding: unix
# End:
