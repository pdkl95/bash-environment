#!/bin/bash

_env_list()         { ls   "${bashEV[envDIR]}"                 ; }
_env_dir_for()      { echo "${bashEV[envDIR]}/$1"              ; }
_env_loader_for()   { echo "${bashEV[envDIR]}/$1/_load.bash"   ; }
_env_unloader_for() { echo "${bashEV[envDIR]}/$1/_unload.bash" ; }

_env_check() {
    [[ -d "$(_env_dir_for "$1")" ]] && [[ -e "$(_env_loader_for "$1")" ]]
}


_env_run_local_helper() {
    export bashEV_ENV_NAME="$1"
    export bashEV_ENV_SCRIPT="$2"
    export bashEV_ENV_DIR="$(_env_dir_for "$1")"
    #dinfo "Local Environment:"
    #dinfo "    bashEV_ENV_NAME=\"${bashEV_ENV_NAME}\""
    #dinfo "    bashEV_ENV_DIR=\"${bashEV_ENV_DIR}\""
    #dinfo "    bashEV_ENV_SCRIPT=\"${bashEV_ENV_SCRIPT}\""
    #dbegin "running env-local script"

    source "${bashEV_ENV_SCRIPT}"
    #dend $? "error running ${bashEV_ENV_SCRIPT}"

    unset bashEV_ENV_NAME bashEV_ENV_SCRIPT bashEV_ENV_DIR
}

_env_unload_current() {
    if [[ -n "${bashEV[envCURRENT]}" ]] ; then
        local unloader="$(_env_unloader_for "${bashEV[envCURRENT]}")"
        #dinfo "Environment UNLOAD: ${env}"
        _env_run_local_helper "${bashEV[envCURRENT]}" "${unloader}"
        bashEV[envCURRENT]=""
    fi
}

_env_load_now() {
    local env="$1"
    local loader="$(_env_loader_for "${env}")"
    #dinfo "Environment LOAD: ${env}"
    #dinfo "Environment LOADER: ${loader}"
    _env_run_local_helper "${env}" "${loader}"
    bashEV[envCURRENT]="$env"
}

_env_load() {
    if _env_check "$1" ; then
        _env_unload_current
        _env_load_now "$1"
    else
        derror "_env_load: ERROR: Bad Environment: \"${1}\"!"
        derror "_env_load: Expected this Environment to have:"
        derror "_env_load:     $(_env_loader_for "${1}")"
    fi
}

# Local Variables:
# mode: sh
# sh-basic-offset: 4
# sh-shell: bash
# coding: unix
# End:
