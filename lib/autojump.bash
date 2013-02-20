#!/bin/bash

_autojump()
{
        local cur
        cur=${COMP_WORDS[*]:1}
        comps=$(autojump --bash --complete $cur)
        while read i
        do
            COMPREPLY=("${COMPREPLY[@]}" "${i}")
        done <<EOF
        $comps
EOF
}
complete -F _autojump j

_autojump_files()
{
    if [[ ${COMP_WORDS[COMP_CWORD]} == *__* ]]; then
        local cur
        #cur=${COMP_WORDS[*]:1}
        cur=${COMP_WORDS[COMP_CWORD]}
        comps=$(autojump --bash --complete $cur)
        while read i
        do
            COMPREPLY=("${COMPREPLY[@]}" "${i}")
        done <<EOF
        $comps
EOF
    fi
}
complete -o default -o bashdefault -F _autojump_files cp mv meld diff kdiff3 vim emacs

export AUTOJUMP_DATA_DIR="${XDG_DATA_HOME}/autojump"


_autojump_add() {
    export AUTOJUMP_KEEP_ALL_ENTRIES=1
    local i
    for i in "$@"; do
        autojump -a "${i}"
    done
    unset AUTOJUMP_KEEP_ALL_ENTRIES
}

_autojump_update_cwd() {
    _autojump_add "${PWD}" >/dev/null 2>"${AUTOJUMP_DATA_DIR}/errors"
}

_prompt_command__autojump_update() {
    (_autojump_update_cwd & )> /dev/null
}

#_add_prompt_command autojump_update

j() {
    if [[ ${@} =~ -.* ]]; then
        autojump ${@}
        return
    fi

    new_path="$(autojump $@)"
    if [ -d "${new_path}" ]; then
        if [[ $TERM =~ 256 ]]; then
            echo -e "\e[38;5;226;48;5;19m${new_path}\e[0m"
        else
            echo "${new_path}"
        fi
        cd "${new_path}"
    else
        echo "autojump: directory '${@}' not found"
        echo "Try \`autojump --help\` for more information."
        false
    fi
}

# Local Variables:
# mode: sh
# sh-basic-offset: 4
# sh-shell: bash
# coding: unix
# End:
