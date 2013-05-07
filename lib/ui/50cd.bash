#!/bin/bash

CDSTACK=( "${PWD}" )

if [[ "$(type -t cd)" == "builtin" ]] ; then
    cd() {
        local len=${#CDSTACK[@]}
        if [[ "$1" =~ ^-[0-9]+$ ]] ; then
            local i=${1#-}
            if (( i > len )) ; then
                derror "not a valid CDSTACK number: $i (max is: ${len})"
                return
            fi
            builtin cd "${CDSTACK[$i]}"
        else
            builtin cd "$@"
        fi

        if [[ "${PWD}" != "${OLDPWD}" ]] ; then
            if (( len >= 3 )) ; then
                CDSTACK=( "${PWD}" "${CDSTACK[@]:0:$(( len - 1 ))}" )
            else
                CDSTACK=( "${PWD}" "${CDSTACK[@]}" )
            fi
            #declare -p CDSTACK
        fi
    }
    #dinfo "overriding 'cd'"
else
    dwarn "\"cd\" is not a shell builtin?"
    dwarn "$(type cd)"
fi

# Local Variables:
# mode: sh
# sh-basic-offset: 4
# sh-shell: bash
# coding: unix
# End:
