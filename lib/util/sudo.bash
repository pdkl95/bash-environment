#!/bin/bash


sudo_or_su() {
    if can_run sudo && sudo -l "$@" 2>/dev/null ; then
        sudo "$@"
    else
        if can_run su ; then
            su -c "$*"
        else
            return_error 1 "Not able to run commands as root!"
        fi
    fi
}

gui_sudo_or_su() {
    in_X || return 2

    local MODE=""
    # adapted from su-to-zenmap.sh
    if can_run gksu ; then
        MODE="gksu"
        if [[ -n "${KDE_FULL_SESSION}" ]] ; then
            if can_run kdesu ; then
                MODE="kdesu"
            else
                MODE="kde4su"
            fi
        fi
    elif can_run kdesu ; then
        MODE="kdesu"
    elif can_run /usr/lib/kde4/libexec/kdesu ; then
        MODE="kde4su"
    elif can_run ktsuss ; then
        MODE="ktsuss"
    fi
    xtitle "ROOT: $@"
    case $MODE in
        gksu)
            if can_run_as_sudo "$@" ; then
                gksu --sudo-mode -u root "$@"
                (( $? == 1 )) && return 127
            else
                gksu --su-mode -u root "$@"
            fi
            ;;
        kdesu)  kdesu -u root "$@" ;;
        kde4su) /usr/lib/kde4/libexec/kdesu -u root "$@" ;;
        ktsuss) ktsuss -u root "$@" ;;
        # As a last resort, open a new xterm use sudo/su
        sdterm) xterm -e "sudo -u root $@" ;;
        sterm)  xterm -e "su -l root -c $@" ;;
        *)      return 3 ;;
    esac
}


as_root() {
    [[ $# -lt 1 ]] && return 1

    gui_sudo_or_su "$@"

    case "$?" in
        0|127) return $? ;;
        *)     sudo_or_su "$@" ;;
    esac
}



# Local Variables:
# mode: sh
# sh-basic-offset: 4
# sh-shell: bash
# coding: unix
# End:
