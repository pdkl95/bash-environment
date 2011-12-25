#! /bin/bash
# -*- mode: sh -*-

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

in_X() {
    [[ -n "$XAUTHORITY" ]]
}

can_run() {
    [[ -x "$(command which $1)" ]]
}

can_run_as_sudo() {
    can_run sudo ]] && sudo -l "$@" 2>/dev/null
}

can_run_as_su() {
    can_run su
}
