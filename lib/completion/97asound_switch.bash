#!/bin/bash

_asound_switch() {
    COMPREPLY=()
    local word="${COMP_WORDS[COMP_CWORD]}"

    local -a opt=()
    if [[ "$word" =~ ^- ]] ; then
        opt+=( -h -v --help --version )
    fi

    if [ "$COMP_CWORD" -eq 1 ]; then
        opt+=( $(asound_switch commands) )
    else
        case "${COMP_WORDS[1]}" in
            u|use|t|toggle)
                opt+=( $(asound_switch list) )
                ;;
            *) : ;;
        esac
    fi
    local completions="${opt[@]}"
    COMPREPLY=( $(compgen -W "$completions" -- "$word") )
}

complete -F _asound_switch asound_switch
