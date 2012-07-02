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
    : ${MP_BIN:=mplayer2}
    MP_BIN="$(which "${MP_BIN}")"

    if ! [[ -x "${MP_BIN}" ]] ; then
        derror "Missing mplayer binary - MP_BIN=${MP_BIN}"
        return 1
    fi

    # serialize the settings onto the command line
    dshowexec mplayer_launcher "${MP_BIN}" "${MP_NAMEPAD}" "${MP_BINOPT}" "$@"
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
