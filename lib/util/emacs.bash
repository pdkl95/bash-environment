#! /bin/bash
# -*- mode: sh -*-

emacsclient_run() {
    command emacsclient-emacs-24 "$@" ;
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
export VISUAL="emacs_tty"
