# -*- mode: sh -*-

# Shell is non-interactive?
[[ $- != *i* ]] && return


######################
###  Interactive!  ###
######################

# sandbox all the various bash stuff
export PDKL_HOME="/home/endymion"
export PDKL_BASHDIR="${PDKL_HOME}/.bash"

echoerr() {
    echo "$@" 1>&2;
}

return_error() {
    local err="$1"
    shift
    echo "ERROR (${FUNCNAME[1]}): $@"
    return $err
}

is_defined() {
    declare -p $1 >/dev/null 2>&1
}

is_cmd() {
    command command type $1 &>/dev/null || return 1
}

safe_load() {
    [ -f "$1" ] && source "$1"
}

load_sh() {
    safe_load "${PDKL_BASHDIR}/$1.sh"
}

defer_load_sh() {
    local file="$(readlink -f "${PDKL_BASHDIR}/$1.sh")"
    shift
    # REQUIRED: $file must redefine all elements of "$@"
    #           it will cause $file to randomly be reloaded
    for x in "$@" ; do
        eval "$x() { source '"$file"'; $x \"\$@\"; }"
    done
}

add_path_prefix() {
    [[ "$PATH" =~ "$1" ]] || PATH="$1:$PATH"
}

add_project_root() {
    add_path_prefix "$1/bin"
}

add_project_root "${PDKL_HOME}"

set -E
#set -e

# all real work is done elsewhere
load_sh "options"
load_sh "ansicolor"
load_sh "env"
#load_sh "rvm_gemset_prompt"
load_sh "functions"
load_sh "prompt"
load_sh "aliases"
load_sh "completion"
defer_load_sh "mplayer_helper" "m" "mm"

unset safe_load load_sh add_path_prefix add_project_root
