#!/bin/bash

##########################################
# select an editor fin order of preference

first_available_editor() {
    local e
    for e in "$@" ; do
        if is_cmd "${e}" ; then
            echo "${e}"
            return 0
        fi
    done
    derror "WARNING: no suitable choice for $EDITOR could be found!"
    derror "!!!!!!!! Falling ack the exing EDITOR=$EDITOR"
    return 1
}

export EDITOR="$(first_available_editor emacs_tty emacs zile nano)"
export VISUAL="$(first_available_editor emacs_frame_wait me gedit "${EDITOR}")"

unset first_available_editor

_me() {
    #prepare_for_editing "$@"
    command me "$@" &disown
}
alias me="_me"
