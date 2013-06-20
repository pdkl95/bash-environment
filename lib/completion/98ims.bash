#!/bin/bash

_ims() {
    COMPREPLY=()
    local word="${COMP_WORDS[COMP_CWORD]}"
    local -a opt=( -h -l --help --list )
    opt+=( $(ims --list) )
    local completions="${opt[@]}"
    COMPREPLY=( $(compgen -W "$completions" -- "$word") )
}

complete -F _ims ims
