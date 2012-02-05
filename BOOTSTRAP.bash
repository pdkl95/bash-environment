#! /bin/bash
# -*- mode: sh -*-



# these perl-isms are sometimes convenient
# durring the init process,...
__DIR__() {
    local SRC="${BASH_SOURCE[0]}"
    while [ -h "$SRC" ] ; do
        SRC="$(readlink "$SRC")"
    done
    cd -P "$(dirname "$SRC")" && pwd
}

__FILE__() {
    echo "$(__DIR__)/${BASH_SOURCE[0]}"
}

## enable compiled-C builtins for several
## common tools for speed
plugsdir="/usr/lib64/bash"
for plugname in finfo basename dirname cat cut pushd popd; do
    plug="${plugdir}/${plugname}"
    [[ -r "${plug}" ]] && enable -f "${plug}" ${plugname}
    # ??? should provide a fallback if they don't exist ???
done
unset plug plugdir plugname


############################################
###  DEFINE THE BASH-ENVIRONMENT LAYOUT  ###
############################################

# put a bunch of it on this hash to try and reduce
# clutter in teh main namespace
declare -A bashEV

# save what we were launched as so
# we can run the correct bootup
# sequence later on
bashEV[bootAS]="${0##*/}"

# save the launch conditions
bashEV[bootCMD]="$0"
bashEV[bootARGS]="$@"
bashEV[bootSRC]="${BASH_SOURCE[0]}"

# canonicalize the path to ourself
# in case symlinks are involved
bashEV[SRC]="$(readlink -f "${BASH_SOURCE[0]}")"

# standard ROOT of the bash envionment is
# the directory that BOOTSTRAP.bash is in
bashEV[bootDIR]="$(dirname "${bashEV[SRC]}")"
bashEV[ROOT]="$(cd -P "${bashEV[bootDIR]}" && pwd)"

bashEV[LIB]="${bashEV[ROOT]}/lib"
bashEV[BIN]="${bashEV[ROOT]}/bin"
bashEV[ETC]="${bashEV[ROOT]}/etc"
bashEV[VAR]="${bashEV[ROOT]}/var"
bashEV[RC]="${bashEV[ROOT]/RC}"

bashEV[INIT]="${bashEV[LIB]}/_init.bash"
bashEV[HOME]="${bashEV_HOME:-${HOME}}"
bashEV[VERBOSE]="${bashEV_VERBOSE:-2}"

bashEV_env_list() {
    for key in "${!bashEV[@]}" ; do
        local val="${bashEV["$key"]}"
        echo "bashEV[$key]=$val"
    done
}

bashEV_env() {
    echo "declare -AX  bashEV"
    bashEV_env_list | sort
}

###################
# loading helpers #
###################

bashEV_safe_load() {
    [ -f "$1" ] && source "$1"
}

bashEV_find_lib() {
    if [[ "$1" =~ ^/ ]] ; then
        echo "$1"
    elif [[ "$1" =~ .sh$ ]] ; then
        echo "${bashEV[LIB]}/$1"
    else
        echo "${bashEV[LIB]}/$1.bash"
    fi
}

bashEV_load() {
    bashEV_safe_load "$(bashEV_find_lib "$1")"
}

# like load in all way, but is a mark for caching
bashEV_include() {
    bashEV_load "$@"
}

bashEV_load_minimal() {
    bashEV_load "env"
}

bashEV_load_standard() {
    bashEV_load "ui"
    bashEV_load "editor"
    bashEV_load "app"
    bashEV_load "aliases"
    bashEV_load "completion"
}

bashEV_boot_as_script() {
    bashEV_load_minimal
    bashEV_load
}

bashEV_boot_as_bashrc() {
    bashEV_load_minimal
    bashEV_load_standard
}

bashEV_boot_as_profile() {
    bashEV_boot_as_bashrc || return
    local rc="${bashEV[ETC]}/profile.bash"
    [[ -e "$rc" ]] && source "$rc"
}

bashEV_boot_as_command() {
    local cmd="$1"
    #echo "BOOT_CMD: $cmd"
    bashEV_load "editor"
    echo "CMD> $cmd "${bashEV[bootARGS]}""
    $cmd ${bashEV[bootARGS]}
}

bashEV_autostart() {
    local name="$1"
    #echo "name=$name"
    if [[ -z "$name" ]] ; then
        name="${bashEV[bootAS]}"
    fi

    [[ "$name" =~ ^-?bash$ ]]  && name='.bashrc'

    #echo "AUTOSTART: $name"
    case "$name" in
        bashev)        bashEV_boot_as_script  ;;
        .bashrc)       bashEV_boot_as_bashrc  ;;
        .bash_profile) bashEV_boot_as_profile ;;
        *)             bashEV_boot_as_command "$name" ;;
    esac

}

is_defined() {
    declare -p $1 >/dev/null 2>&1
}

is_undef() {
    ! is_defined "$@"
}

is_cmd() {
    #command command type $1 &>/dev/null || return 1
    command hash "$1" 2>&-
}


export bashEV
