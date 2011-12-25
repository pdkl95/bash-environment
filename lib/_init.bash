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
: ${bashENV:=$(dirname ${bashLIB})}
: ${bashETC:=${bashENV}/etc}
: ${bashRC:=${bashENV}/rc}

: ${bashVERBOSE:=2}

# put a bunch of it on this hash to try and reduce
# clutter in teh main namespace
declare -A rcpath

# the paths (outside our env) that BASH expects
# to find things
rcpath[inputrc_standard]="$HOME/.inputrc"
rcpath[bashrc_standard]="$HOME/.bashrc"
rcpath[profile_standard]="$HOME/.bash_profile"
rcpath[logout_standard]="$HOME/.bash_logout"

# actual internal path of those same files, where
# they can be easily picked up by GIT
rcpath[inputrc]="${bashETC}/inputrc"
rcpath[bashrc]="${bashRC}/rc.bash"
rcpath[profile]="${bashRC}/profile.bash"
rcpath[logout]="${bashRC}/logout.bash"

## messaging/prints to the user that include
## the context of who call it to help with debugging

echo_debug() {
    if (( $bashVERBOSE > 2 )) ; then
        local from="${FUNCNAME[1]}"
        echo "<${from}> $@"
    fi
}

echo_info() {
    if (( $bashVERBOSE > 1 )) ; then
        local from="${FUNCNAME[1]}"
        echo "<${from}> $@"
    fi
}

echo_error() {
    if (( $bashVERBOSE > 0 )) ; then
        local from="${FUNCNAME[1]}"
        echo "<${from}> $@" 1>&2
    fi
}

echo_and_run() {
    if (( $bashVERBOSE > 1 )) ; then
        local from="${FUNCNAME[1]}"
        echo "<${from}> EXEC: $@"
    fi
    "$@"
}

# similar to Perl's die - give up with a nice error message
die() {
    echo_error "FATAL ERROR!!"
    for line in "$@"; do
        echo_error "$line"
    done
    exit -1
}


##########################################################
# A few utilities to help reduce repetition in the code  #
# for the rest of our envrionment.                       #
# These *must* be run _before_ anything else in $bashLIB #
##########################################################

is_defined() {
    declare -p $1 >/dev/null 2>&1
}

is_cmd() {
    command command type $1 &>/dev/null || return 1
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

load_bash_lib() {
    if [[ "$1" =~ ^/ ]] ; then
        safe_load "$1"
    elif [[ "$1" =~ .sh$ ]] ; then
        safe_load ="${bashLIB}/$1"
    else
        safe_load "${bashLIB}/$1.bash"
    fi
}

defer_load_bash_lib() {
    local file="$(readlink -f "${bashENV}/$1.sh")" ; shift
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
