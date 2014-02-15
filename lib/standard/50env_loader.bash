#!/bin/bash

declare -a _loadenv_environs=()
declare    _loadenv_top_environ

_loadenv_var() {
    local env_name="$1" var_name="$2"
    #dwarn echo "_LOADENV_${env_name^^}_${var_name^^}" 1>&2
    echo "_LOADENV_${env_name^^}_${var_name^^}"
}

_loadenv_get() {
    #dwarn _get "$(_loadenv_var "$@")" 1>&2
    _get "$(_loadenv_var "$@")"
}

_loadenv_set() {
    local env_name="$1" var_name="$2" val="$3"
    #dwarn _set "$(_loadenv_var "${env_name}" "${var_name}")" "${val}" 1>&2
    _set "$(_loadenv_var "${env_name}" "${var_name}")" "${val}"
}

_loadenv_unset() {
    local env_name="$1" var_name="$2"
    #dwarn unset "$(_loadenv_var "$@")" 1>&2
    unset "$(_loadenv_var "$@")"
}

_loadenv_push_var() {
    local env_name="$1" var_name="$2" val="$3"
    if [[ -v "${var_name}" ]] ; then
        _loadenv_set "${env_name}" "${var_name}" "${!var_name}"
    fi
    _set "${var_name}" "${val}"
}

_loadenv_pop_var() {
    local env_name="$1" var_name="$2"
    local oldval="$(_loadenv_get "${env_name}" "${var_name}")"
    if (( $? == 0 )) ; then
        _loadenv_unset "${env_name}" "${var_name}"
        _set "${var_name}" "${old_val}"
    else
        unset "${var_name}"
    fi
}

_loadenv_unset_all() {
    local env_name="$1"
    local prefix="$(_loadenv_var "${env_name}" "")"
    if _is_varname "${prefix}" ; then
        for varname in $(eval 'echo ${!'"${prefix}"'@}') ; do
            unset "${varname}"
        done
    else
        echo "NOT A VALID VARIABLE PREFIX: '${prefix}'"
        return 1
    fi
}

showenv() {
    echo -n "$(_Cff 36)ENVIRONS$(_Cff 33):  "
    local -i n=${#_loadenv_environs}
    local b="$(tput bold)"
    local r="$(_C00)"
    
    if (( n < 1 )) ; then
        echo -n "$(_Cff 126)${b}(${r}"
        echo -n "$(_Cff 252)$(_Cbb 53)none${r}"
        echo -n "$(_Cff 126)${b})${r}"
    else
        local first=true
        for e in "${_loadenv_environs[@]}" ; do
            if ${first} ; then
                first=false
            else
                echo -n " "
                echo -n "${b}$(_Cff 245)-"
                echo -n "$(_Cff 244)>${r}"
                echo -n " "
            fi

            echo -n "$(_Cff  24)$(_Cbb 17)${b}{${r}"
            echo -n "$(_Cff 159)$(_Cbb 22)${e}${r}"
            echo -n "$(_Cff  24)$(_Cbb 17)${b}}${r}"
        done

        _C00
    fi

    echo
}

_loadenv() {
    local env_name="$1"

    _loadenv_push_var "${env_name}" "PROMPT_PREFIX" "${env_name,,}"

    source "${bashEV[ROOT]}/env/${env_name}"
}

_unloadenv() {
    local env_name="$1"
    local unloader="unloadenv_${env_name}"

    if [[ $(type -t "${unloader}") == "function" ]] ; then
        ${unloader}
        unset -f ${unloader}
    fi

    _loadenv_pop_var "${env_name}" "PROMPT_PREFIX"

    _loadenv_unset_all "${env_name}"
}

pushenv() {
    local env_name="$1" ; shift
    
    for e in "${_loadenv_environs[@]}" ; do
        if [[ "$e" == "${env_name}" ]] ; then
            dwarn "Environ \"${e}\" already loaded"
            showenv
            return
        fi
    done

    _loadenv_environs+=( "${env_name}" )
    _loadenv_top_environ="${env_name}"

    _loadenv "${env_name}"

    showenv
}

popenv() {
    local -i n=${#_loadenv_environs[@]}
    if (( n < 1 )) ; then
        showenv
        return
    fi
    
    local -i popidx=$(( ${#_loadenv_environs[@]} - 1 ))
    local -i last=$(( popidx - 1 ))

    local deadenv="${_loadenv_environs[${popidx}]}"
    _unloadenv "${deadenv}"
    _loadenv_environs=( ${_loadenv_environs[@]:0:${popidx}} )

    if (( last < 0 )) ; then
        _loadenv_top_environ=
    else
        _loadenv_top_environ="${_loadenv_environs[${last}]}"
    fi

    showenv
}

_pushenv() {
    COMPREPLY=($(compgen -W "$(ls ${bashEV[ROOT]}/env)" -- "${COMP_WORDS[COMP_CWORD]}"))
    return 0
}
complete -F _pushenv pushenv


# Local Variables:
# mode: sh
# sh-basic-offset: 4
# sh-shell: bash
# coding: unix
# End:
