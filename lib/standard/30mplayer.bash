##############################
###  MPLAYER HELPER SUITE  ###
##############################

m_recent_local() {
    local CHOOSE_FILE_TITLE="mplayer_launch_listrecent"
    local CHOOSE_FILE_ICON="video"

    local file
    while file=$(choose_recent_local_file) ; do
        m "$file"
    done
}

_mplayer_launcher() {
    local -x MP_BINOPT="${1}" ; shift
    local -x MP_BIN="$(which "${MP_BIN:-mplayer2}")"

    if ! [[ -x "${MP_BIN}" ]] ; then
        derror "Missing mplayer binary - MP_BIN=${MP_BIN}"
        return 1
    fi

    local -x MPLAYEROPT="${opts[@]}"
    local -x MP_NAMEPAD=""

    local -a opts args
    local i last=""

    for i in "$@" ; do
        if [[ -n "${last}" ]] ; then
            opts+=( "${i}" )
            if [[ "${i}" =~ ^- ]] ; then
                last="${i}"
            else
                last=""
            fi
        elif [[ "$i" =~ ^- ]] ; then
            opts+=( "${i}" )
            last="${i}"
        else
            args+=( "${i}" )
        fi
    done

    dshowexec mplayer_launcher "${args[@]}"
}

#######################################################################
# exported wrappers

mplay()     { _mplayer_launcher ''                  "$@" ; }
mverbose()  { _mplayer_launcher '-v'                "$@" ; }
mcomp()     { _mplayer_launcher '-profile comp'     "$@" ; }
mcompmore() { _mplayer_launcher '-profile compmore' "$@" ; }
m3d()       { _mplayer_launcher '-profile m.3d -v'  "$@" ; }

if ! is_cmd mp ; then
    alias mp="mplayer2"
fi

declare -a MPLAYER_M_MODES=( play player2 comp compmore verbose 3d )
declare MPLAYER_M_MODE=play

m() {
    case ${MPLAYER_M_MODE} in
        play | player2 | comp | compmore | verbose | 3d)
            local cmd="m${MPLAYER_M_MODE}"
            $cmd "$@"
            ;;
        *)
            if [[ -n "${MPLAYER_M_MODE}" ]] ; then
                dwarn "not a valid mode: MPLAYER_M_MODE=\"${MPLAYER_M_MODE}\""
                dwarn "falling back to the basic \"play\" mode"
            else
                MPLAYER_M_MODE=play
                dwarn "Setting the mode to the default:"
                dwarn "    $(declare -p MPLAYER_M_MODE)"
            fi
            mplay "$@"
            ;;
    esac
}

maspect()   {
    local orig_aspect="$1" ; shift
    local aspect="${orig_aspect#*-}"
    aspect="$(echo "${aspect}" | tr '/' ':')"

    if [[ "${aspect}" =~ ^[0-9]+[:][0-9]+$ ]] ; then
        _mplayer_launcher "-aspect ${aspect}" "$@"
    else
        derror "Not an aspect ratio: \"${aspect}\" (\"${orig_aspect}\")"
    fi
}

_shift_completion() {
    local func="$1" cmd="$2"
    local -i arg_offset=${3}
    shift 3

    local -i offset=$(( 1 + $arg_offset ))
    local -i nargs=$(( $# - offset ))
    local OLDCMD="${COMP_WORDS[@]:0:${offset}}"

    COMP_WORDS=("$cmd" ${COMP_WORDS[@]:$offset})
    COMP_CWORD=$(($COMP_CWORD-$arg_offset))

    local origlen=${#COMP_LINE}
    COMP_LINE="${COMP_LINE/${OLDCMD}/${cmd}}"
    local newlen=${#COMP_LINE}

    local delta=$(( origlen-newlen ))
    COMP_POINT=$(( COMP_POINT - delta ))

    $func
}

_maspect() {
  if [ "$COMP_CWORD" -eq 1 ]; then
      local word="${COMP_WORDS[COMP_CWORD]}"
      COMPREPLY=( $(compgen -W "1-16/9 2-16/10 3-4/3" -- "$word") )
  else
      _shift_completion _mplayer mplayer 1 "$@"
  fi
}

alias ma="maspect"
alias m9="maspect 16:9"
alias m1="maspect 16:10"
alias m3="maspect 4:3"

complete -F _maspect m{aspect,a}

#complete -F _mplayer m{1,3,9}
#complete -F _mplayer m{,comp,compmore}


mmode() {
    local newmode="$1"
    if [[ -z "${MPLAYER_M_MODE}" ]] ; then
        if (( $# < 1 )) || [[ -z "$1" ]] ; then
            local oldPS3="${PS3}"
            local PS3="mplayer profile for the \"m\" launcher: "
            select mode in "${MPLAYER_M_MODES[@]}" ; do
                if [[ -z "${REPLY}" ]] ; then
                    MPLAYER_M_MODE="${REPLY}"
                fi
                break;
            done
            PS3="${oldPS3}"
        fi
    else
        echo "orig MPLAYER_M_MODE='${MPLAYER_M_MODE}'"
    fi

    case ${MPLAYER_M_MODE} in
        play | player2 | comp | compmore | verbose | 3d)
            MPLAYER_M_MODE="${m}"
            ;;
        *)  MPLAYER_M_MODE="play"
            if [[ -n "${m}" ]] ; then
                dwarn "unknown mode \"${m}\""
                dwarn "resetting back to basic \"${MPLAYER_M_MODE}\" mode"
            fi
            ;;
    esac
    dinfo "MPLAYER_M_MODE=\"${MPLAYER_M_MODE}\""
}
complete -W "${MPLAYER_M_MODES[*]}" mmode
