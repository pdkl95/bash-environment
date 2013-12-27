#! /bin/bash
# -*- mode: sh -*-


##################################################
# set some defaults

if is_cmd less ; then
    if [[ -z "$PAGER" ]] ; then
        export PAGER=less
    fi
    export LESS="--ignore-case -R -M --shift 5"
    if [[ -z "$LESSOPEN" ]] && is_cmd lesspipe ; then
        LESSOPEN="|lesspipe %s"
    fi
    export LESSCOLOR=yes
    if [[ "$TERM" =~ 256color ]] ; then
        export LESSCOLORIZER=colorize
        export LESS_TERMCAP_mb=$'\E[0;48;5;17;38;5;161m'
        export LESS_TERMCAP_md=$'\E[0;48;5;17;38;5;117m'
        export LESS_TERMCAP_me=$'\E[0m'
        export LESS_TERMCAP_se=$'\E[0m'
        export LESS_TERMCAP_so=$'\E[0;48;5;22;38;5;122m'
        export LESS_TERMCAP_us=$'\E[4;48;5;233;38;5;208m'
        export LESS_TERMCAP_ue=$'\E[0m'
    fi
else
    if [[ -z "$PAGER" ]] ; then
        export PAGER=more
    fi
fi
