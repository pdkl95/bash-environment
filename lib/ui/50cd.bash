#!/bin/bash

CDSTACK=( "${PWD}" )

_cd__cdstack() {
    local len=${#CDSTACK[@]}

    if (( $# > 0 )) && [[ "$1" =~ ^-[0-9]+$ ]] ; then
        local i=${1#-}
        if (( i > len )) ; then
            derror "not a valid CDSTACK number: $i (max is: ${len})"
            return
        fi
        builtin cd "${CDSTACK[$i]}"
    else
        builtin cd "$@"
    fi

    if (( len >= 5 )) ; then
        CDSTACK=( "${PWD}" "${CDSTACK[@]:0:$(( len - 1 ))}" )
    else
        CDSTACK=( "${PWD}" "${CDSTACK[@]}" )
    fi
}
CD="_cd__cdstack"

    
if [[ "$(type -t cd)" == "builtin" ]] ; then
    cd() {
        if type -t "${CD}" 2>&1 >/dev/null "${CD}" ; then
            ${CD} "$@"
        else
            builtin cd "$@"
        fi
    }
fi

# Local Variables:
# mode: sh
# sh-basic-offset: 4
# sh-shell: bash
# coding: unix
# End:
