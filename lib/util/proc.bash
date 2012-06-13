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

pstree-list() {
    my_ps f "$@"
}

my_ps_tree_wide() {
    pstree-list-wide ww "$@"
}

# pseudo 'pstree' from ps; has more info
alias pp="my_ps_tree"
alias ppw="my_ps_tree ww"

# also, fixup the actual "pstree" (requires wide output, but
# can be very easy to read
is_cmd pstree && alias pstree="pstree -Gp"


stat1() {
  local D=${1:-$PWD/*}; stat -c %a\ %A\ \ A\ %x\ \ M\ %y\ \ C\ %z\ \ %N ${D} |sed -e 's/ [0-9:]\{8\}\.[0-9]\{9\} -[0-9]\+//g' |tr  -d "\`\'"|sort -r;
}

list_open_ports() {
    sudo lsof -Pi | grep LISTEN
}

list_sockets_by_user() {
    local U="${1:${USER}}"
    sudo lsof -P -i -a -u "$U"
}
