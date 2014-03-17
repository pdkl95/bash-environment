#!/bin/bash

_declare() {
    local cur prev words cword
    _init_completion || return

    if [[ $1 == @(declare|typeset) ]] ; then
        case "$prev" in
            -f) COMPREPLY=( $( compgen -A function -- "$cur" ) ) ;;
            -p) COMPREPLY=( $( compgen -A variable -- "$cur" ) ) ;;
            *)
                if [[ "$cur" == -* ]]; then
                    COMPREPLY=( $( compgen -W '$( _parse_usage "$1" )' -- "$cur" ) )
                else
                    COMPREPLY=( "() $( type -- ${COMP_WORDS[1]} | sed -e 1,2d )" )
                fi
                ;;
        esac
    elif [[ $cword -eq 1 ]] ; then
        COMPREPLY=( $( compgen -A function -- "$cur" ) )
    else
        COMPREPLY=( "() $( type -- ${words[1]} | sed -e 1,2d )" )
    fi

}
complete -F _declare declare


# Local Variables:
# mode: sh
# sh-basic-offset: 4
# sh-shell: bash
# coding: unix
# End:

