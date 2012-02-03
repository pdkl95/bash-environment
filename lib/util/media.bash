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

if is_cmd sqlite3 ; then
    sqlite_cleanup() {
        if [[ -w "$1" ]] ; then
            sqlite3 "$1" VACUUM
            sqlite3 "$1" REINDEX
        fi
    }

    vacuum_firefox() {
        for db in "$HOME"/.mozilla/firefox/????????.*/*.sqlite ; do
            echo "VACUUMING: ${db}"
            sqlite_cleanup "$db"
        done
    }
fi

#nuke_site() {
#    local host="$1"
#    firefox -new-tab "http://meyerweb.com/eric/tools/gmap/hydesim.html?dll=$(GET "$host" | grep ICBM | sed -e "s/<meta content='//" -e "s/'.*//" -e 's/ //')&yd=22&zm=12&op=156"
#}
