
_homegit_env() {
    local -x GIT_DIR="${HOME}/src/dotfiles/.git"
    local -x GIT_WORK_TREE="${HOME}"

    local cmd="$1" ; shift
    "${cmd}" "$@"
}

homegit()  {
    _homegit_env git  "$@"
}

homegitk() {
    _homegit_env gitk "$@"
}

_homegit_active() {
    if [[ -v GIT_DIR ]] || [[ -v GIT_WORK_TREE ]] ; then
        return 1
    fi
    if dir_is_git_managed "${PWD}" ; then
        return 1
    fi
    [[ "${PWD}" == "${HOME}" ]]
}

if [[ "$(type -t git)" == file ]] ; then
    git() {
        if _homegit_active ; then
            homegit "$@"
        else
            "$(type -P git)" "$@"
        fi
    }
fi
