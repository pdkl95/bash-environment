#!/bin/bash

_lstree_find() {
    local pr="$1" ; shift
    find -L "${@}" -type f -printf "${pr}%p\n"
}
_lstree_sort() {
    local sort="$1" ; shift
    _lstree_find "${sort} " "${@}" | sort -n | cut -d' ' -f2-
}

lstree() {
    local sort="%p" long=false
    while (( $# > 0 )) ; do
        case $1 in
            -l) long=true  ; shift 1 ;;
            -S) sort="%s"  ; shift 1 ;;
            -c) sort="%C@" ; shift 1 ;;
            -t) sort="%T@" ; shift 1 ;;
            -u) sort="%A@" ; shift 1 ;;
            --) shift ; break ;;
            -*) echo "unknown option: $1" 1>&2 ; return 1 ;;
            *)  break ;;
        esac
    done

    local SRC=( "$@" )
    [[ ${#SRC} -lt 1 ]] && SRC+=( '.' )

    if $long ; then
        _lstree_sort "${sort}" "${SRC[@]}" | ls_format_long
    else
        _lstree_sort "${sort}" "${SRC[@]}" | ls_format
    fi
}
alias lstree_size="lstree -S"
alias lstree_atime="lstree -u"
alias lstree_ctime="lstree -c"
alias lstree_mtime="lstree -t"
alias lst="lstree"
alias lsts="lstree -S -l"
alias lstt="lstree -t -l"

cfind()     { find "$@" -printf "%p\n" | ls_format      ; }
cfindlong() { find "$@" -printf "%p\n" | ls_format_long ; }



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
