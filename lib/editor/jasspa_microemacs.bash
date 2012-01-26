#! /bin/bash
# -*- mode: sh -*-

#############################
###  MicroEmacs (JASSPA)  ###
#############################

JASSPA_HOME="${HOME}/.jasspa"
MEBACKUPPATH="${JASSPA_HOME}/backup/"
MEBACKUPSUB="sX/X!X"

export MEBACKUPPATH MEBACKUPSUB

_me() {
    prepare_for_editing "$@"
    if is_git_managed ; then
        echo me -B "$@"
        me -B "$@"
    else
        echo me "$@"
        me "$@"
    fi
}

alias me="_me"
