#!/bin/bash

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



# a USER-VISIBLE wrapper around library loading
require() {
    #bashEV_load "util/$1"
    bashEV_load "$1"
}

in_X() {
    [[ -n "$XAUTHORITY" ]]
}

can_run() {
    [[ -x "$(command which $1)" ]]
}

is_defined() {
    declare -p $1 >/dev/null 2>&1
}

is_undef() {
    ! is_defined "$@"
}

have() {
    unset -v have; command command type $1 &>/dev/null && have="yes" || return 1;
}

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


# Local Variables:
# mode: sh
# sh-basic-offset: 4
# sh-shell: bash
# coding: unix
# End:
