#! /bin/bash
# -*- mode: sh -*-

bashEV_include "app/git"
bashEV_include "app/mplayer"

# all man pages!
man() {
    for i ; do
        xtitle man -a $(basename $1|tr -d .[:digit:])
        command man -a "$i"
    done
}

colorize() {
    local lang="${1:-cl}"
    local mode="terminal256"
#    local style="friendly"
#    local style="railscasts"
    local style="twilight"
    pygmentize -f $mode -l $lang -O style=$style -F tokenmerge
}

ytdl-fixname() {
    local name="$1"
    local ext="${name##*.}"
    local realname="${name%-???????????.*}.${ext}"
    echo "***  /\\ Stripping off the youtube ID that youtube-dl appended:"
    echo "*** / /  ORIG>> $name"
    echo "*** \\/  FIXED>> $realname"
    mv "$name" "$realname"
}

ytdl-opt() {
    echo -n " --console-title"
    echo -n " --continue"
    echo -n " --title"
    echo -n " --prefer-free-formats"
}

yt-get-url() {
    local url="$url"
    local opt="$(ytdl-opt)"
    local file ret

    echo "*** Asking youtube-dl for the filename ***"
    local fopt="$opt --get-filename"
    echo youtube-dl $fopt "${url}"
    file="$(youtube-dl $fopt "$url")"
    echo "*** youtube-dl filename is: ${file}"

    echo "*** Handing off to youtube-dl to fetch the file..."    
    echo    youtube-dl $opt "$url"
    command youtube-dl $opt "$url" ; ret=$?
    echo "RETVAL WAS: $ret"
    if [[ -e "$file" ]] && [[ ! -e "${file}.part" ]] ; then
        echo "*** Download should be finished finished; fixing the filename"
        ytdl-fixname "$file"
    else
        echo "*** ERROR! youtube-dl failed?!"
    fi
    return $ret
}

yt() {
    echo "*** Attempting to download $# video URLs"
    for url in "$@"; do
        yt-get-url "$url"
    done
    echo "*** Successfully fetched $# videos!"
}



# sqlite_cleanup() {
#     if [[ -w "$1" ]] ; then
#         sqlite3 "$1" VACUUM
#         sqlite3 "$1" REINDEX
#     fi
# }

# vacuum_firefox() {
#     for db in "$HOME"/.mozilla/firefox/????????.*/*.sqlite ; do
#         echo "VACUUMING: ${db}"
#         sqlite_cleanup "$db"
#     done
# }


#nuke_site() {
#    local host="$1"
#    firefox -new-tab "http://meyerweb.com/eric/tools/gmap/hydesim.html?dll=$(GET "$host" | grep ICBM | sed -e "s/<meta content='//" -e "s/'.*//" -e 's/ //')&yd=22&zm=12&op=156"
#}
