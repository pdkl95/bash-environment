#! /bin/bash
# -*- mode: sh -*-

_emacsclient() {
    command ${EMACSCLIENT:-emacsclient} --alternate-editor="" "$@"
}
# trap random calls to "emacsclient", so
# can enforce specific options
alias emacsclient="_emacsclient"

emacs_eval()         { emacsclient --eval                   "$@" ; }
emacs_tty()          { emacsclient --tty                    "$@" ; }
emacs_frame_wait()   { emacsclient --create-frame           "$@" ; }
emacs_frame_nowait() { emacsclient --create-frame --no-wait "$@" ; }

emacs_edit_as_root() {
    emacsclient -c -a emacs "/sudo:root@localhost:$1"
}

e() {
    if [[ -e "$1" ]] && can_edit "$1" ; then
        emacs_frame_nowait "$@"
    else
        if [[ -e "$1" ]] ; then
            yad --image=gtk-dialog-warning --window-icon=gtk-dialog-warning --title="read-only file: $file" --text "Trying to open a read-only file:\n    $file\nShould we OPEN it as root?\nOr should be simply view a read-only COPY?" --center --on-top --selectable-labels --button=gtk-open:1 --button=gtk-copy:2 --button=gtk-cancel:0
            case $? in
                1) emacs_edit_as_root "$@" ;;
                2) emacs_frame_nowait "$@" ;;
                *) echo "NOT opening \"$1\"!" ;;
            esac
        else
            create_empty_file "$1"
            emacs_frame_nowait "$@"
        fi
    fi
}

# now that we have these,. rewrite EDITOR to match
# but backup the old versions first
export NOT_EMACS_EDITOR="$EDITOR"
export NOT_EMACS_VISUAL="$VISUAL"
export EDITOR="emacs_tty"
export VISUAL="${EDITOR}"


###################################
# Map it all to some easy shortcuts

alias er="emacs_edit_as_root"
alias et="emacs_tty"
alias ex="emacs_frame_nowait"

# trap emacs itself so it goes through
# the emacsclient wrapper
alias emacs="emacs_tty"
# and for good measure...
alias xemacs="emacs_frame_wait"
