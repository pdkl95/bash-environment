#! /bin/bash
# -*- mode: sh -*-

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
