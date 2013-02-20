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

m() {
    local MP_BINOPT=''
    _mplayer_launcher "$@"
}
mm() {
    local MP_BINOPT='-v'
    _mplayer_launcher "$@"
}
m3d() {
    local MP_BINOPT='-profile m.3d -v'
    _mplayer_launcher "$@"
}
mdbg()   {
    local MP_BINOPT='-v -v -v -msglevel demux=0'
    _mplayer_launcher "$@"
}
mn() {
    local MP_BIN="mplayer" MP_NAMEPAD="-" MP_BINOPT="-quiet"
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


if ! is_cmd mp ; then
    alias mp="mplayer2"
fi

if ! is_cmd mc ; then
    alias mc="mcomp"
fi

if ! is_cmd mcm ; then
    alias mcm="mcompmore"
fi
