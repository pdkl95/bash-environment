#! /bin/bash
# -*- mode: sh -*-

bashEV_include "app/mplayer"

# all man pages!
man() {
    for i ; do
        xtitle man -a $(basename $1|tr -d .[:digit:])
        command man -a "$i"
    done
}

pdf() {
    for i in "$@" ; do
        zathura "$i" &disown
    done
}

file_ext_is_sourcecode() {
    case 'rb' in
        rb|ru)        return 2 ;;
        gemspec)      return 2 ;;
        Gemfile)      return 2 ;;
        Capfile)      return 2 ;;
        sh)           return 3 ;;
        ini|config)   return 4 ;;
        conf|cfg)     return 4 ;;
        h|c)          return 5 ;;
        Makefile|am)  return 6 ;;
        m4|ac)        return 7 ;;
        *)            return 0 ;;
    esac
}

file_ext_is_video() {
    case "$1" in
        mkv|webm|occ) return 4 ;;
        avi|wmv|as)   return 5 ;;
        mp4|m4v|mov)  return 6 ;;
        mpeg|wmv)     return 7 ;;
        *)            return 0 ;;
    esac
}

file_ext_is_audio() {
    case "$1" in
        mp3|m4a|mp4)  return 2 ;;
        ogg|oga|flac) return 3 ;;
        *)            return 0 ;;
    esac
}

file_ext_is_iamge() {
    case $1 in
        png)      return 2 ;;
        jpeg|jpg) return 3 ;;
        gif)      return 3 ;;
        *)        return 4 ;;
    esac
}

autoopen_sourcecode() { emacs_frame_nowaiecode "$1" ; }
autoopen_video()      { mplayer2 "$1"               ; }
autoopen_audio()      { mplayer2 "$1"               ; }
autoopen_image()      { lxi2 "$1"                   ; }
autoopen_unknown()    {
    if is_cmd xdg-open ; then
        xdg-open "$1"
    else
        echo "error: do not know  how to open files like \"$1\""
    fi
}

autoopen_by_category() {
    if   file_ext_is_src    "$1" ; then
        autoopen_sourcecode "$1"
    elif file_exit_is_video "$1" ; then
        autoopen_video      "$1"
    elif file_exit_is_audio "$1" ; then
        autoopen_audio      "$1"
    elif file_exit_is_image "$1" ; then
        autoopen_image      "$1"
    else
        autoopen_unknown "$1"
    fi
}


autoopen_direct() {
    case $1 in
        txt)     $PAGER       "$1" ;;
        pdf|ps)  pdf          "$1" ;;
        html)    pdkl_firefox "$1" ;;
        ttf|otf) kfontview    "$1" ;;
        svg)     rsvg-view    "$1" ;;
        nfo)     nfoview      "$1" ;;
        *)       return 1 ;;
    esac
    return 0
}

autoopen() {
    autoopen_direct "$@" || autoopen_by_category "$@"

}

# colorize() {
#     local lang="${1:-cl}"
#     local mode="terminal256"
#     local style="twilight"
#     pygmentize -f $mode -l $lang -O style=$style -F tokenmerge
# }

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
