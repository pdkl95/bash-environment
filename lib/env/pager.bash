#! /bin/bash
# -*- mode: sh -*-


##################################################
# set some defaults

if is_cmd less ; then
    if [[ -z "$PAGER" ]] ; then
        export PAGER=less
    fi
    export LESS="-R -M --shift 5"
    if [[ -z "$LESSOPEN" ]] && is_cmd lesspipe ; then
        LESSOPEN="|lesspipe %s"
    fi
    export LESSCOLOR=yes
    if is_cmd colorize ; then
        export LESSCOLORIZER=colorize
    fi
    xtitle_for less "LESS: "
else
    if [[ -z "$PAGER" ]] ; then
        export PAGER=more
    fi
    xtitle_for more "MORE: "
fi
