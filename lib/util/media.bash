#!/bin/bash
# -*- mode: sh -*-

mplayer_ident() {
     mplayer2 -msglevel all=0 -identify -frames 0 "$@"  2> /dev/null
}

di.fm-playlists() {
    curl -s http://www.di.fm/ | awk -F '"' '/href="http:.*\.pls.*96k/ {print $2}' | sort | awk -F '/|\.' '{print $(NF-1) " " $0}'
}

di.fm() {
    zenity --lisl \
        --width 500 --height 500 \
        --column 'radio' --column 'url' \
        --print-column 2 | xargs mplayer
}

mplayer_play_yt() {
    mplayer -fs -quiet $(youtube-dl -g "$1")
}

mplayer_fb() {
    mplayer -vo fbdev $1 -fs -subcp ${2:-cp1251} -vf scale=${3:-1280:720}
}
