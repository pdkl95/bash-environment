#! /bin/bash
# do nothing if completion is off globally
if [ -x "$(complete -p)" ]; then
    return
fi

# bashcomp provided pre-load
BASH_COMPLETION="/etc/bash_completion.d/base"
source "/usr/share/bash-completion/.pre"

function load_completion_dir {
    [[ -r "$1/base" ]] && source "$1/base"
    for file in "$1"/* ; do
        [[ "$file" == "$1/base" ]] || source "$file"
    done
}
load_completion_dir "/etc/bash_completion.d"
load_completion_dir "${HOME}/.bash_completion.d"
[ -n "${rvm_path}" ] && safe_load "${rvm_path}/scripts/completion"
load_completion_dir "${PDKL_BASHDIR}/completion.d"

# bashcomp provided post-load
source "/usr/share/bash-completion/.post"
unset load_completion_dir
