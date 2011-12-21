#! /bin/bash
# -*- mode: sh -*-


#########################################
### process monitoring and manipulating #
#########################################

cps() {
    ps -u root U `whoami` --forest -o pid,stat,tty,user,command |ccze -m ansi
}

my_ps() {
    ps --deselect --ppid 2 "$@" -o pid,user,%cpu,%mem,nlwp,stat,bsdstart,vsz,rss,cmd --sort=bsdstart
}

my_ps_tree() {
    my_ps f "$@"
}

my_ps_tree_wide() {
    my_ps_tree ww
}

stat1() {
  local D=${1:-$PWD/*}; stat -c %a\ %A\ \ A\ %x\ \ M\ %y\ \ C\ %z\ \ %N ${D} |sed -e 's/ [0-9:]\{8\}\.[0-9]\{9\} -[0-9]\+//g' |tr  -d "\`\'"|sort -r;
}

list_open_ports() {
    as_root lsof -Pi | grep LISTEN
}

list_sockets_by_user() {
    local U="${1:${USER}}"
    as_root lsof -P -i -a -u "$U"
}
