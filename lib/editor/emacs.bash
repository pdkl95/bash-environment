#! /bin/bash
# -*- mode: sh -*-

emacsclient_run() {
    prepare_for_editing "$@"
    export AUTOSTART_EMACS_CMD="$@"
    command emacsclient-emacs-24 --alternate-editor="$HOME/src/scripts/bin/autostart_emacs_daemon" "$@"
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
export EDITOR="emacs_extern_wrapper.bash"
export VISUAL="${EDITOR}"


###################################
# Map it all to some easy shortcuts

alias E="emacs_eval"
alias e="emacs_frame_nowait"
alias et="emacs_tty"

# trap emacs itself so it goes through
# the emacsclient wrapper
alias emacs="emacs_frame_wait"
# trap random calls to "emacsclient", so
# can enforce specific options
alias emacsclient="emacs_frame_wait"
# and for good measure...
alias xemacs="emacs_frame_wait"
