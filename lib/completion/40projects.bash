#!/bin/bash

_projects() {
    COMPREPLY=()
    local word="${COMP_WORDS[COMP_CWORD]}"
    local -a opt=()
    opt+=( $(listprojects) )
    local completions="${opt[@]}"
    COMPREPLY=( $(compgen -W "$completions" -- "$word") )
}

alias pcd=cd
complete -F _projects pcd
