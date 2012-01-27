#! /bin/bash
# -*- mode: sh -*-

############################################
###  DEFINE THE BASH-ENVIRONMENT LAYOUT  ###
#############################################

#_bsrc="${BASH_SOURCE[0]}"
#while [ -h "${_bsrc}" ] ; do _bsrcE="$(readlink "${_bsrc}")"; done
_bsrc="$(readlink -f "${BASH_SOURCE[0]}")"
_bsrc_dir="$( cd -P "$( dirname "${_bsrc}" )" && pwd )"
: ${bashLIB:=${_bsrc_dir}}
unset _bsrc _bsrc_dir

: ${bashHOME:=${HOME}}
: ${bashENVIRO:=$(dirname ${bashLIB})}
: ${bashETC:=${bashENV}/etc}
: ${bashRC:=${bashENV}/rc}
: ${bashINIT:=${bashLIB}/_init.bash}

: ${bashVERBOSE:=2}

export bashHOME bash

# put a bunch of it on this hash to try and reduce
# clutter in teh main namespace
declare -A bashEV

# cache the bash* vars in the array we export
bashEV[HOME]="${bashHOME}"
bashEV[ENV]="${bashENV}"
bashEV[ROOT]="${bashROOT}"
bashEV[ETC]="${bashETC}"
bashEV[RC]="${bashRC}"
bashEV[INIT]="${bashINIT}"
bashEV[VERBOSE]="${bashVERBOSE}"

# the paths (outside our env) that BASH expects
# to find things
bashEV[inputrc_standard]="$HOME/.inputrc"
bashEV[bashrc_standard]="$HOME/.bashrc"
bashEV[profile_standard]="$HOME/.bash_profile"
bashEV[logout_standard]="$HOME/.bash_logout"

# and the rc paths
bashEV[inputrc]="${bashETC}/inputrc"
bashEV[bashrc]="${bashRC}/rc.bash"
bashEV[profile]="${bashRC}/profile.bash"
bashEV[logout]="${bashRC}/logout.bash"



##########################################################
# A few utilities to help reduce repetition in the code  #
# for the rest of our envrionment.                       #
# These *must* be run _before_ anything else in $bashLIB #
##########################################################

is_defined() {
    declare -p $1 >/dev/null 2>&1
}

is_cmd() {
    #command command type $1 &>/dev/null || return 1
    command hash "$1" 2>&-
}

: ${DEBUG_MSG_TRUE:=TRUE/zero}
: ${DEBUG_MSG_FALSE:=FALSE/non-zero}

yn() {
    local RETVAL=$?
    if (( $# > 0 )) ; then
        local cmd="$1" ; shift
        $cmd "$@"
        RETVAL=$?
    fi
    if (( $RETVAL == 0 )) ; then
        echo "${DEBUG_MSG_TRUE}"
    else
        echo "${DEBUG_MSG_FALSE}"
    fi
    return $RETVAL
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


###################
# loading helpers #
###################

safe_load() {
    [ -f "$1" ] && source "$1"
}

parse_bash_libname() {
    if [[ "$1" =~ ^/ ]] ; then
        echo "$1"
    elif [[ "$1" =~ .sh$ ]] ; then
        echo "${bashLIB}/$1"
    else
        echo "${bashLIB}/$1.bash"
    fi
}

load_bash_lib() {
    safe_load "$(parse_bash_libname "$1")"
}

defer_load_bash_lib() {
    local file="$(parse_bash_libname "$1")" ; shift
    # REQUIRED: $file must redefine all elements of "$@"
    #           it will cause $file to randomly be reloaded
    for x in "$@" ; do
        eval "$x() { source '"$file"'; $x \"\$@\"; }"
    done
}


add_path_prefix() {
    [[ "$PATH" =~ "$1" ]] || PATH="$1:$PATH"
}

add_path_suffix() {
    [[ "$PATH" =~ "$1" ]] || PATH="$PATH:$1"
}
