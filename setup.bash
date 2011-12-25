#!/bin/bash

. "$( cd -P "$( dirname "$(readlink -f "${BASH_SOURCE[0]}")" )" && pwd )/lib/_init.bash"

#set -x
#set -v

symlink_to_homedir() {
    local from="${rcpath[${1}]}" to="${rcpath[${1}_standard]}"
    if [[ -f "$to" ]] ; then
        die "something already exists at: $to"
    else
        echo_and_run ln -s "$from" "$to"
    fi
}

saferm_homedir_symlink() {
    local path="${rcpath[${1}_standard]}"
    if [[ -L "$path" ]] ; then
        echo_info "removing symlink at: $path"
        echo_and_run rm -f "$path"
    elif [[ -e "$path" ]] ; then
        echo_error "Not our symlink! Lost management of: $path"
    fi
}

declare -a MANAGED_DOTFILES=(profile bashrc inputrc logout)
echo_debug "managing ${#MANAGED_DOTFILES[@]} dotfiles"
managed_dotfiles_setup() {
    local i N=${#MANAGED_DOTFILES[@]}
    for ((i = 0; i < N; i++)); do
        echo_debug "Managing: ${MANAGED_DOTFILES[i]}"
        symlink_to_homedir "${MANAGED_DOTFILES[i]}"
    done
}
managed_dotfiles_restore() {
    local i N=${#MANAGED_DOTFILES[@]}
    for ((i = 0; i < N; i++)); do
        echo_debug "Undoing management: ${MANAGED_DOTFILES[i]}"
        saferm_homedir_symlink "${MANAGED_DOTFILES[i]}"
    done
}

managed_dotfiles_restore
managed_dotfiles_setup


echo_info "setup finished!"
