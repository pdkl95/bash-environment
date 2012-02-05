#! /bin/bash
# -*- mode: sh -*-

emacsclient_run() {
    local client="emacsclient-emacs-24"
    local autostart="${bashEV[BIN]}/emacs_daemon-autostart"
    local startfail="${bashEV[BIN]}/emacs_daemon-startfail"
    local optauto="--alternate-editor=\"$autostart\""
    local optfail="--alternate-editor=\"$startfail\""

    prepare_for_editing "$@"
    export AUTOSTART_EMACS_CMD="${client} ${optfail} $@"
    echo command ${client} ${optauto} "$@"
    command ${client} ${optauto} "$@"
    unset AUTOSTART_EMACS_CMD
}
emacs_eval()         { emacsclient_run --eval                   "$@" ; }
emacs_tty()          { emacsclient_run --tty                    "$@" ; }
emacs_frame_wait()   { emacsclient_run --create-frame           "$@" ; }
emacs_frame_nowait() { emacsclient_run --create-frame --no-wait "$@" ; }


# now that we have these,. rewrite EDITOR to match
# but backup the old versions first
export NOT_EMACS_EDITOR="$EDITOR"
export NOT_EMACS_VISUAL="$VISUAL"
export EDITOR="emacs_tty"
export VISUAL="${EDITOR}"


###################################
# Map it all to some easy shortcuts

alias E="emacs_eval"
alias e="emacs_tty "
alias et="emacs_tty"
alias ex="emacs_frame_nowait"

# trap emacs itself so it goes through
# the emacsclient wrapper
alias emacs="emacs_tty"
# trap random calls to "emacsclient", so
# can enforce specific options
alias emacsclient="emacs_frame_wait"
# and for good measure...
alias xemacs="emacs_frame_wait"
