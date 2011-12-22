function compalias {
    local f="$1"
    shift
    [ "$(type -t "$f")" = function ] && complete "$@"
}

compalias _git -o default -o nospace -F _git g
compalias _rake -F _rake ber
#compalias _mplayer -F _mplayer mplayer2

unset compalias
