#! /bin/bash
# -*- mode: sh -*-

# do nothing if completion is off globally
if [ -x "$(complete -p)" ]; then
    return
fi

load_compdir() {
    [[ -d "$1" ]] || return
    [[ -r "$1/base" ]] && source "$1/base"
    for file in "$1"/* ; do
        [[ "$file" == "$1/base" ]] || source "$file"
    done
}

compalias() {
    local f="$1"
    shift
    [ "$(type -t "$f")" = function ] && complete -F "$f" "$@"
}

# load standard system-provided completions
# WARNING: probably GENTOO specific?
[ -z "$BASH_COMPLETION" ] && BASH_COMPLETION="/etc/bash_completion.d/base"
safe_load "/usr/share/bash-completion/.pre"
load_compdir "/etc/bash_completion.d"
safe_load "/usr/share/bash-completion/.post"

# finally, load our custom libs
load_compdir "${bashLIB}/completion"

# and connect to any of the simple aliases, etc
compalias _git -o default -o nospace g
compalias _rake bake
compalias _mplayer mplayer2

unset load_compdir compalias
