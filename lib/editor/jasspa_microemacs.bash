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
    local OPT=""
    prepare_for_editing "$@"
    is_git_managed && OPT="-B"
    command me $OPT "$@" &
}

alias me="_me"
