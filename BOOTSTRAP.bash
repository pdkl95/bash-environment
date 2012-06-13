#! /bin/bash
# -!- bash -!-

## START with the system environment
source /etc/profile.env

## trip out some usless junk
unset CONFIG_PROTECT CONFIG_PROTECT_MASK HG OPENCL_PROFILE PACKAGE_MANAGER PRELINK_PATH_MASK ROOTPATH SSH_ASKPASS VBOX_APP_HOME

## fix the path with the basics
PATH="/usr/local/bin:/usr/bin:/bin:${PATH}"
export PATH


## enable compiled-C builtins for several
## common tools for speed
plugdir="/usr/lib64/bash"
for plugname in finfo basename dirname cut pushd; do
    plug="${plugdir}/${plugname}"
    if [[ -r "${plug}" ]] ; then
        enable -f "${plug}" ${plugname}
        #echo "enabled: ${plug}"
    else
        echo "missing bash extension: ${plug}"
    fi
done
unset plug plugdir plugname

is_cmd() {
    command hash "$1" 2>&-
}

# store most bashEV local vars in a hash, so
# we aren't polluting the global namespace with
# a huge amount of junk

declare -A bashEV

# save what we were launched as so
# we can run the correct bootup
# sequence later on
bashEV[bootAS]="${0##*/}"

############################################
###  DEFINE THE BASH-ENVIRONMENT LAYOUT  ###
############################################

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

bashEV[INIT]="${bashEV[LIB]}/_init.bash"
bashEV[HOME]="${bashEV_HOME:-${HOME}}"
bashEV[VERBOSE]="${bashEV_VERBOSE:-2}"
bashEV[COMPLOCAL]="${bashEV[ETC]}/completion"

bashEV[envDIR]="${bashEV[LIB]}/env.d"
bashEV[envDEFAULT]="general"

###################
# loading helpers #
###################

_bashEV_safe_load() {
    [ -f "$1" ] && source "$1"
}

_bashEV_find_lib() {
    if [[ "$1" =~ ^/ ]] ; then
        echo "$1"
    elif [[ "$1" =~ .sh$ ]] ; then
        echo "${bashEV[LIB]}/$1"
    else
        echo "${bashEV[LIB]}/$1.bash"
    fi
}

bashEV_load() {
    _bashEV_safe_load "$(_bashEV_find_lib "$1")"
}

# like load in all way, but is a mark for caching
bashEV_include() {
    bashEV_load "$@"
}

bashEV_load_minimal() {
    bashEV_load "_base"
}

bashEV_load_standard() {
    bashEV_load "switchenv"
    bashEV_load "ui"
    bashEV_load "editor"
    bashEV_load "app"
    bashEV_load "aliases"
    bashEV_load "util"
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
