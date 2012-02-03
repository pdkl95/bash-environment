#! /bin/bash
# -*- mode: sh -*-

bashEV_include "app/git"
bashEV_include "app/mplayer"


fullenv() {
    for _a in {A..Z} {a..z} ; do
        _z=\${!${_a}*}
        for _i in `eval echo "${_z}"` ; do
            echo -e "$_i: ${!_i}"
        done
    done | cat -Tsv
}

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


# Repeat n times command.
repeat() {
    local i max
    max=$1
    shift
    for ((i=1; i <= max ; i++)); do
        eval "$@"
    done
}


my_ip_from_outsie_prespective() {
    curl ifconfig.me
}
alias my_ip="my_ip_from_outside_prespective"


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


#nuke_site() {
#    local host="$1"
#    firefox -new-tab "http://meyerweb.com/eric/tools/gmap/hydesim.html?dll=$(GET "$host" | grep ICBM | sed -e "s/<meta content='//" -e "s/'.*//" -e 's/ //')&yd=22&zm=12&op=156"
#}
