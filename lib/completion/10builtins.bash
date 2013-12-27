#!/bin/bash

_declare() {
    local cur prev words

    COMPREPLY=()
    _get_comp_words_by_ref cur prev

    case "$prev" in
        -f) COMPREPLY=( $( compgen -A function -- "$cur" ) )
            ;;
        -p) COMPREPLY=( $( compgen -A variable -- "$cur" ) )
            ;;
        *)
            if [[ "$cur" == -* ]]; then
                COMPREPLY=( $( compgen -W '-a -f -F -i -r -x -p' -- "$cur" ) )
            else
                COMPREPLY=( "() $( type -- ${COMP_WORDS[1]} | sed -e 1,2d )" )
            fi
            ;;
    esac
}
complete -F _declare declare


# Local Variables:
# mode: shell-script
# sh-indent-comment: 1
# sh-basic-offset: 4
# sh-shell: bash
# indent-tabs-mode: nil
# coding: unix
# End:
