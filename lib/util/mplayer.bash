##############################
###  MPLAYER HELPER SUITE  ###
##############################

m_recent_local() {
    local CHOOSE_FILE_TITLE="mplayer_launch_listrecent"
    local CHOOSE_FILE_ICON="video"
    while file=$(choose_recent_local_file) ; do
        m "$file"
    done
}

_mplayer_launcher() {
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

    : ${MP_BIN:=mplayer2}
    MP_BIN="$(which "${MP_BIN}")"

    if ! [[ -x "${MP_BIN}" ]] ; then
        derror "Missing mplayer binary - MP_BIN=${MP_BIN}"
        return 1
    fi

    export MPLAYEROPT="${opts[@]}"
    : ${MP_NAMEPAD:=}
    : ${MP_BINOPT:=}
    # serialize the settings onto the command line
    export MP_BIN MP_NAMEPAD MP_BINOPT
    dshowexec mplayer_launcher "${args[@]}"
}

#######################################################################
# exported wrappers

mplay() {
     local MP_BINOPT=''
     _mplayer_launcher "$@"
}
mverbose() {
    local MP_BINOPT='-v'
    _mplayer_launcher "$@"
}
mcomp() {
    local MP_BINOPT='-profile comp'
    _mplayer_launcher "$@"
}
mcompmore() {
    local MP_BINOPT='-profile compmore'
    _mplayer_launcher "$@"
}
m3d() {
    local MP_BINOPT='-profile m.3d -v'
    _mplayer_launcher "$@"
}
# mdbg()   {
#     local MP_BINOPT='-v -v -v -msglevel demux=0'
#     _mplayer_launcher "$@"
# }
# mn() {
#     local MP_BIN="mplayer" MP_NAMEPAD="-" MP_BINOPT="-quiet"
#     _mplayer_launcher "$@"
# }


if ! is_cmd mp ; then
    alias mp="mplayer2"
fi

declare MPLAYER_M_MODE=m
declare -a MPLAYER_M_MODES=( play player2 comp compmore verbose 3d )

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
            fi
            mplay "$@"
            ;;
    esac
}

mmode() {
    local m="$1"
    if (( $# < 1 )) ; then
        local oldPS3="${PS3}"
        PS3="mplayer profile for the \"m\" launcher: "
        select m in "${MPLAYER_M_MODES[@]}" ; do
            if [[ -z "${m}" ]] ; then
                m="${REPLY}"
            fi
            break;
        done
        PS3="${oldPS3}"
    fi
    case ${m} in
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
