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

noop() {
    # Just run whawt we were passed unchanged.
    # A replacment for 'nice' and similar,
    # without actually affectig anything.
    "$@"
}

is_cmd() {
    command hash "$1" 2>&-
}

first_available_cmd() {
    local cmd
    for cmd in "$@" ; do
        if $(is_cmd "${cmd}") ; then
            echo "${cmd}"
            return 0
        fi
    done
    return 1
}

_split_at() {
    local IFS="$1" x
    for x in "$2" ; do
        echo "${x}"
    done
}

for_each_split_by() {
    local sep="$1" ; shift
    local str
    for str in "$@" ; do
        _split_at "${sep}" "${str}"
    done
}

pathlike_split() {
    for_each_split_by ":" "$@"
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
bashEV[VAR]="${bashEV[HOME]}/var"

bashEV[VERBOSE]="${bashEV_VERBOSE:-2}"

#bashEV[envDIR]="${bashEV[LIB]}/env.d"
#bashEV[envDEFAULT]="general"

PROMPT_COMMAND=""

###############################################
### for compatability with the XDG          ###
### desktop-app spec that is fairly copmmon ###
###############################################


XDG_CONFIG_HOME=${bashEV[VAR]}/config
XDG_DATA_HOME=${bashEV[VAR]}/share
XDG_CACHE_HOME=${bashEV[VAR]}/cache
XDG_RUNTIME_DIR=${bashEV[VAR]}/run
export XDG_CONFIG_HOME XDG_DATA_HOME XDG_CACHE_HOME XDG_RUNTIME_DIR

: ${XDG_CONFIG_DIRS=/etc/xdg}
: ${XDG_DATA_DIRS:=/usr/share/gnome:/usr/local/share:/usr/share}
export XDG_CONFIG_DIRS XDG_DATA_DIRS


###################
# loading helpers #
###################

declare LASTCMD_RETVAL=""

_run_prompt_commands() {
    LASTCMD_RETVAL="$?"
    if ! [[ -v PROMPT_COMMAND_FUNCTIONS ]] ; then
        PROMPT_COMMAND_FUNCTIONS=$(compgen -A function _prompt_command__)
    fi
    local func
    for func in ${PROMPT_COMMAND_FUNCTIONS} ; do
        ${func}
    done
}

PROMPT_COMMAND="_run_prompt_commands"

_bashEV_safe_load() {
    if [[ -f "$1" ]] ; then
        source "$1"
    else
        if [[ -e "$1" ]] ; then
            local msg="not a directory"
        else
            local msg="directory does not exist"
        fi
        echo "_bashEV_save_load: cannot load \"${1}\" - ${msg}" 1>&2
    fi
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
    local path="$(_bashEV_find_lib "$1")"
    #echo "bashEV_load:      loading param: ${1}"
    #echo "bashEV_load:             as dir: \"${path}\""
    bashEV_safe_load "${path}"
}

bashEV_load_dir() {
    local dir="$1"
    local any_ext="${2:-false}"

    if ! [[ -d "${dir}" ]] ; then
        #echo "bashEV_load_dir: error - not a directory: \"${dir}\""
        return 1
    fi
    #echo "bashEV_load_dir:  loading dir:  \"${path#${bashEV[LIB]}/}\""

    if $any_ext ; then
        local ext=""
    else
        local ext=".bash"
    fi

    local name_re="[0-9][0-9]*${ext}"

    local file
    while IFS= read file ; do
        #echo "bashEV_lood_dir:     - loading: \"${file#${bashEV[LIB]}/}\""
        source "${file}"
    done < <(find "${dir}" -maxdepth 1 -type f -name "${name_re}" | sort)

    return 0
}

bashEV_include() {
    local relpath="$1"
    local path="${bashEV[LIB]}/${relpath}"
    if [[ -d "${path}" ]] ; then
        #echo "direct loading directory: ${path}"
        bashEV_load_dir "${path}"
    else
        if ! [[ "${path}" =~ .*\.bash$ ]] ; then
            path="${path}.bash"
        fi
        bashEV_load "${path}"
    fi
}

bashEV_boot_as_bashrc() {
    bashEV_include "_base"
    bashEV_include "standard"
}

bashEV_boot_as_profile() {
    bashEV_boot_as_bashrc || return
    local rc="${bashEV[ETC]}/profile.bash"
    [[ -e "$rc" ]] && source "$rc"
}

bashEV_boot_as_command() {
    local cmd="$1"
    #echo "BOOT_CMD: $cmd"
    bashEV_include "10editor"
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
        .bashrc)       bashEV_boot_as_bashrc  ;;
        .bash_profile) bashEV_boot_as_profile ;;
        *)             bashEV_boot_as_command "$name" ;;
    esac

}
