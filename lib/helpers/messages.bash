#!/bin/bash

########################
###  Error Messages  ###
########################

cmderror() {
    local type="$1" cmd="$2" msg="$3"

    # assume it was $msg if we only got one of [cmd, msg]
    if [[ -z "$msg" ]] && [[ -n "$cmd" ]] ; then
        msg="${cmd}"
        cmd=""
    fi

    if (( $bashVERBOSE > 1 )) ; then
        echo -n "$(pcolor DARK!red '-')$(pcolor red '=')$(pcolor BOLD!red '<') "
        echo -n "$(pcolor YELLOW/red "COMMAND ERROR")"
        [[ -n "${type}" ]] && echo -n "$(pcolor RED ' - ')$(pcolor YELLOW/red "${type}")"
        echo " $(pcolor BOLD!red '>')$(pcolor red '=')$(pcolor DARK!red '-')"

        drawline() {
            local PFX="$1" C="$2" TXT="$3"
            if [[ -n "$TXT"  ]] ; then
                #echo -n "    "
                echo -n "$(pcolor red 'error')"
                echo -n "$(pcolor RED "$PFX")"
                echo -n "$(pcolor YELLOW ':') "
                echo    "$(pcolor "$C" "$TXT")"
            fi
        }
        drawline 'CMD' 'black/green' "${cmd}"
        drawline 'MSG' 'YELLOW'      "${msg}"
    elif (( $bashVERBOSE > 0 )) ; then
        echo "ERROR: ${cmd:-(unknown command)}: ${msg}"
    else
        echo "${msg}"
    fi

    return 255
}

fatalerror() {
    cmderror "!!! SERIOUS PROBLEM !!!" "$@"
    die "Giving up; calling exit()"
}

error()   { cmderror ""                    "$@" ; }
erropt()  { cmderror "Bad Parameter"       "$@" ; }
errfile() { cmderror "File Op Failure"     "$@" ; }
errmisc() { cmderror "Unspecified Problem" "$@" ; }


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
        echo -n "$(pcolor BOLD:yellow "WARNING")"

        [[ -n "${type}" ]] && echo -n "$(pcolor_wrap_angle BOLD:yellow YELLOW/yellow "$type")"

        if [[ -n "${cmd}"  ]] ; then
            echo -n "$(pcolor_wrap_square YELLOW black/green "$cmd")"
        fi

        echo "$(pcolor DIM:yellow ':') $(pcolor BOLD:white "$msg")"
    elif (( $bashVERBOSE > 0 )) ; then
        echo "WARNING: ${msg}"
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
