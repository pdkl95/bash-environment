#! /bin/bash
# -*- mode: sh -*-

: ${TERM:=xterm-256color}
: ${INPUTRC:=$HOME/.inputrc}

PATH="\
${bashEV[HOME]}/.bash/bin:\
${HOME}/bin:\
${HOME}/.rbenv/shims:\
${HOME}/node_modules/.bin:\
${HOME}/games/minecraft/bin:\
${HOME}/.cw/bin:\
${PATH}"

NOCOLOR_PIPE=1

export TERM INPUTRC PATH NOCOLOR_PIPE


# guess color mode from the terminal name
# if it's not set already
[[ "$TERM" =~ xterm ]] && TERM="xterm-256color"

if is_undef USE_ANSI_COLOR ; then
    case ${TERM:-dummy} in
        linux*|con80*|con132*|console|xterm*|vt*|screen*|putty|Eterm|dtterm|ansi|rxvt|gnome*|*color*)
            USE_ANSI_COLOR=true
            [[ -z "${COLOR_MODE}" ]] && COLOR_MODE="ansi-16color"
            ;;
        *)  USE_ANSI_COLOR=false ;;
    esac
fi

if is_undef USE_ANSI_256COLOR ; then
    if [[ $TERM =~ -256color$ ]] ; then
        USE_ANSI_256COLOR=true
        COLOR_MODE="ansi-256color"
    else
        USE_ANSI_256COLOR=false
    fi
fi

export USE_ANSI_COLOR USE_ANSI_256COLOR COLOR_ON

# macro to generate a standard "xtitle"
# wrapper around a command
xtitle_for() {
    local cmd="$1" title="$2" ; shift 2
    local xt="xtitle \"$title\$@\""
    #echo "XT> $xt"
    local cm="command $cmd \"\$@\""
    #echo "CM> $cm"
    local func="_$cmd() { $xt ; $cm ; }"
    #echo "FUNC> $func"
    eval $func
    eval "alias $cmd=_$cmd"
}

xtpush() {
    local t="$1" ; shift
    local cmd="$1" ; shift

    local old="$xtitlePFX"
    restore_xtitle_prefix() {
        export xtitlePFX="$old"
    }
    trap restore_xtitle_prefix RETURN

    export xtitlePFX="${xtitlePFX}${t} - "
    xtitle ''
    $cmd "$@"

    restore_xtitle_prefix
}

# load other major env sections...
bashEV_include "env/bashopts"
bashEV_include "env/locale"
bashEV_include "env/pager"
bashEV_include "env/history"
bashEV_include "env/misc"
bashEV_include "env/LS_COLORS"


# misc settings
export GREP_COLORS="rv:mt=38;5;197;1:sl=48;5;234:cx=38;5;247:fn=38;5;039:ln=38;5;208:bn=38;5;227:se=48;5;017;38;5;57"
export TIMEFORMAT=$'\nreal %3R\tuser %3U\tsys %3S\tpcpu %P\n'
export FIGNORE='.o:~'

# *** HACK ***
# Workaround for how Gentoo deals with ruygems. We manage it
# entirely separate from the distory anyway (rbenv/bundler), so this
# has little utility anyway.
export RUBYOPT=""

######################################################
###  and a few other thigns that should always be  ###
###  loaded early and in non-interactive shells    ###
######################################################

# a USER-VISIBLE wrapper around library loading
require() {
    bashEV_load "util/$1"
}

in_X() {
    [[ -n "$XAUTHORITY" ]]
}

can_run() {
    [[ -x "$(command which $1)" ]]
}

can_run_as_sudo() {
    can_run sudo && sudo -l "$@" 2>/dev/null
}

can_run_as_su() {
    can_run su
}

sudo_or_su() {
    if can_run_as_sudo "$@" ; then
        sudo "$@"
    else
        if can_run_as_su "$@" ; then
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


# Pull in autoenv from the standard gem checkout location
source "${HOME}/.autoenv/activate.sh"
source "${HOME}/src/autoenv_helpers/init.bash"
