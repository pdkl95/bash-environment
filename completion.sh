# do nothing if completion is off globally
if [ -x "$(complete -p)" ]; then
    return
fi

load_compdir() {
    [[ -r "$1/base" ]] && source "$1/base"
    for file in "$1"/* ; do
        [[ "$file" == "$1/base" ]] || source "$file"
    done
}
#load_completion_dir "/etc/bash_completion.d"
#load_completion_dir "${HOME}/.bash_completion.d"
[ -n "${rvm_path}" ] && safe_load "${rvm_path}/scripts/completion"
load_completion_dir "${PDKL_BASHDIR}/completion.d"

# bashcomp provided pre-load
[ -z "$BASH_COMPLETION" ] && BASH_COMPLETION="/etc/bash_completion.d/base"
safe_load "/usr/share/bash-completion/.pre"
load_compdir "/etc/bash_completion.d"
safe_load "/usr/share/bash-completion/.post"

function compalias {
    local f="$1"
    shift
    [ "$(type -t "$f")" = function ] && complete -F "$f" "$@"
}

load_compdir "${PDKL_BASHDIR}/completion.d"
compalias _git -o default -o nospace g
compalias _rake bake
compalias _mplayer mplayer2
unset compalias
>>>>>>> 1d466762442afcb589724a66f1ca935ed1e9a9ba
=======

# bashcomp provided pre-load
[ -z "$BASH_COMPLETION" ] && BASH_COMPLETION="/etc/bash_completion.d/base"
safe_load "/usr/share/bash-completion/.pre"
load_compdir "/etc/bash_completion.d"
safe_load "/usr/share/bash-completion/.post"

function compalias {
    local f="$1"
    shift
    [ "$(type -t "$f")" = function ] && complete -F "$f" "$@"
}

load_compdir "${PDKL_BASHDIR}/completion.d"
compalias _git -o default -o nospace g
compalias _rake bake
compalias _mplayer mplayer2
unset compalias
>>>>>>> 1d466762442afcb589724a66f1ca935ed1e9a9ba

# bashcomp provided post-load
unset load_compdir
