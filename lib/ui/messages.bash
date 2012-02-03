#!/bin/bash

##################################################
### First some message-printing minor features ###
##################################################

byte2human() {
    declare -a LABELS=('B' 'KB' 'MB' 'GB' 'TB' 'XB' 'PB')
    local magscale=1024 magnitude=0 size=$1

    while (( size >= magscale )) ; do
        (( size=size/magscale ))
        (( magnitude+ ))
    done
   echo "${size}${LABELS[${magnitue}]]}"
}



################################################
###  ALL DEBUG/INFO/PROMPT MESSAGE PRINTING  ###
################################################

upcase()   { echo "$@" | tr 'a-z' 'A-Z' ; }
downcase() { echo "$@" | tr 'A-Z' 'a-z' ; }

_dmsg() {
    echo -ne "$@"
}

_derr() {
    echo -ne "$@" 1>&2
}

_debug_msg() {
    local _PR="_dmsg" NOFROM=false
    local NAME="" ID="" MK="" C="" FROM=""
    local TXT=""

    while getopts "a" ; do
        case "$1" in
            -o|--stdout)  _PR="_dmsg" ; shift ;;
            -e|--stderr)  _PR="_derr" ; shift ;;
            -F|--no-from) NOFROM=true ; shift ;;
            -n|--name)    NAME="$2"   ; shift 2 ;;
            -i|--id)      ID="$2"     ; shift 2 ;;
            -m|--marker)  MK="$2"     ; shift 2 ;;
            -c|--color)   C="$2"      ; shift 2 ;;
            -f|--from)    FROM="$2"   ; shift 2 ;;
            --)           shift ; break ;;
            -*)           return die "Unknown option to _debug_msg: $1" ;;
            *)            TXT="${TXT} $1" ; shift ;;
        esac
    done
    echo ${_PR}
    local MK="$3" C="$4" FROM="$5" ; shift 5

    _PR_from() {
        if (( $bashVERBOSE > 4 )) ; then
            ${_PR} "\e[0;${C}m${NAME}"
            ${_PR} "\e[2;${C}m${MK}"
        elif (( $bashVERBOSE > 3 )) ; then
            ${_PR} "\e[1;${C}m${ID}"
            #${_PR} "\e[0;${C}m${MK}"
            ${_PR} "\e[2;${C}m${MK}"
        fi

        ${_PR} "\e[1;${C}m${FROM}"
    }

    _PR_mkmk() {
        ${_PR} "\e[2;${C}m ${MK}"
        ${_PR} "\e[0;${C}m${MK}"
    }

    _PR_mkpr() {
        ${_PR} "\e[2;${C}m${MK}"
        ${_PR} "\e[0;${C}m>"
    }

    _PR_MK() {
        (( $bashVERBOSE == 2 )) && _PR_mkmk || _PR_mkpr
        ${_PR} "\e[1;${C}m> "
    }

    _PR_prefix() {
        if [[ -n "$FROM" ]] ; then
            $NOFROM || _PR_FROM
            _PR_MK
        fi
    }

    _PR_txt() {
        ${_PR} "\e[0;${37}m"
        ${_PR} "${TXT}"
    }

    _PR_EOLN() {
        ${_PR} "\e[0m"
        ${_PR} "\n"
    }

    _PR_prefix
    _PR_txt
    _PR_EOLN
}

_debug() {
    if (( $bashVERBOSE > 2 )) ; then
        _debug_msg --no-from --stderr --name=DEBUG --id=D '--marker=~' --color=36 "--from=${FUNCNAME[1]}" "$@"
    fi
}

echo_debug() {
    if (( $bashVERBOSE > 2 )) ; then
        _debug_msg --stderr 'DEBUG' 'D' '~' 36 "${FUNCNAME[1]}" "$@"
    fi
}


echo_info() {
    if (( $bashVERBOSE > 1 )) ; then
        _debug_msg --stderr 'INFO'  'I' '-' 32 "${FUNCNAME[1]}" "$@"
    fi
}

echo_error() {
    if (( $bashVERBOSE > 0 )) ; then
        _debug_msg --stdout 'ERROR' 'E' '*' 31 "${FUNCNAME[1]}" "$@"
    fi
}

echo_and_run() {
    if (( $bashVERBOSE > 1 )) ; then
        _debug_msg --stdout 'EXEC'  'X' '!' 35 "${FUNCNAME[1]}" "$@"
    fi
    "$@"
}

# similar to Perl's die - give up with a nice error message
die() {
    echo_error "FATAL ERROR!!"
    for line in "$@"; do
        echo_error "$line"
    done
    exit -1
}


########################
###  Error Messages  ###
########################

cmderror() {
    local type="$1" cmd="$2" msg="$3"
    local X=""

    # assume it was $msg if we only got one of [cmd, msg]
    if [[ -z "$msg" ]] && [[ -n "$cmd" ]] ; then
        msg="${cmd}"
        cmd=""
    fi

    if (( $bashVERBOSE > 1 )) ; then
        X="${X}$(pcolor DARK!red '-')$(pcolor red '=')$(pcolor BOLD!red '<') "
        X="${X}$(pcolor YELLOW/red "COMMAND ERROR")"
        [[ -n "${type}" ]] && X="${X}$(pcolor RED ' - ')$(pcolor YELLOW/red "${type}")"
        echo_error --no-from "${X} $(pcolor BOLD!red '>')$(pcolor red '=')$(pcolor DARK!red '-')"
        X=""

        drawline() {
            local PFX="$1" C="$2" TXT="$3"
            if [[ -n "$TXT"  ]] ; then
                local X=""
                #X="${X}    "
                X="${X}$(pcolor red 'error')"
                X="${X}$(pcolor RED "$PFX")"
                X="${X}$(pcolor YELLOW ':') "
                echo_error --no-from "${X}$(pcolor "$C" "$TXT")"
            fi
        }
        drawline 'CMD' 'black/green' "${cmd}"
        drawline 'MSG' 'YELLOW'      "${msg}"
    elif (( $bashVERBOSE > 0 )) ; then
        echo_error --no-from "ERROR: ${cmd:-(unknown command)}: ${msg}"
    else
        echo_error --no-from "${msg}"
    fi

    return 255
}

error()   { cmderror                              "$@" ; }
errBAD()  { cmderror --type "!!*SERIOUS*ERROR*!!" "$@" ; }
erropt()  { cmderror --type "Bad Parameter"       "$@" ; }
errfile() { cmderror --type "File Op Failure"     "$@" ; }
errmisc() { cmderror --type "Unspecified Problem" "$@" ; }

fatalerror() {
    errBAD "$@"
    die "Giving up; calling exit()"
}


##########################
###  Warning Messages  ###
##########################

cmdwarn() {
    local type="$1" cmd="$2" msg="$3"

    # assume it was $msg if we only got one of [cmd, msg]
    if [[ -z "$msg" ]] && [[ -n "$cmd" ]] ; then
        msg="${cmd}"
        cmd=""
    fi

    [[ -z "$msg" ]] && msg="(unspecified?!)"

    if (( $bashVERBOSE > 1 )) ; then
        local X="${X}$(pcolor BOLD:yellow "WARNING")"

        [[ -n "${type}" ]] && X="${X}$(pcolor_wrap_angle BOLD:yellow YELLOW/yellow "$type")"
        [[ -n "${cmd}"  ]] && X="${X}$(pcolor_wrap_square YELLOW black/green "$cmd")"

        echo_info --no-from "${X}$(pcolor DIM:yellow ':') $(pcolor BOLD:white "$msg")"
    elif (( $bashVERBOSE > 0 )) ; then
        echo_info --no-from "WARNING: ${msg}"
    else
        : # suppress WARNINGs when in minimal-verbosity mode
    fi
}

warn()     { cmdwarn ""      "$@" ; }
warnopt()  { cmdwarn "Param" "$@" ; }
warnfile() { cmdwarn "File"  "$@" ; }
warnmisc() { cmdwarn "Misc"  "$@" ; }



# Local Variables:
# mode: sh
# sh-basic-offset: 4
# sh-shell: bash
# coding: unix
# End:
