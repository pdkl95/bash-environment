#! /bin/bash

# do nothing if completion is off globally
if [ -x "$(complete -p)" ]; then
    return
fi

load_compdir() {
    local file

    #echo "LOADING COMPDIR: \"$1\""
    [[ -d "$1" ]] || return
    [[ -r "$1/base" ]] && source "$1/base"
    for file in "$1"/* ; do
        [[ "$file" == "$1/base" ]] || source "$file"
    done
}

compalias() {
    local f="$1"
    shift
    if [[ "$(type -t "$f")" == 'function' ]] ; then
        complete -F "$f" "$@"
    else
        echo "compalias: completions for \"${f}\" not found"
    fi
}

# load standard system-provided completions
# WARNING: probably GENTOO specific?

BCSYS_DB="/usr/share/bash-completion"
BCSYS_ON="/etc/bash_completion.d"

[[ -z "$BASH_COMPLETION" ]] && BASH_COMPLETION="${BCSYS_ON}/base"

#bashEV_load  "${BCSYS_DB}/.pre"
source "${BCSYS_DB}/.pre"
load_compdir "${BCSYS_ON}"
source  "${BCSYS_DB}/.post"
#bashEV_load "${BCSYS_DB}/.post"

# finally, load our custom libs
load_compdir "${bashEV[LIB]}/completion"

# and connect to any of the simple aliases, etc
compalias _git -o default -o nospace g
compalias _mplayer mplayer2

unset load_compdir BCSYS_ON BCSYS_DB
