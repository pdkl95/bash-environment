#! /bin/bash
# -*- mode: sh -*-


#########################################
### process monitoring and manipulating #
#########################################

cps() {
    ps -u root U `whoami` --forest -o pid,stat,tty,user,command |ccze -m ansi
}

# also, fixup the actual "pstree" (requires wide output, but
# can be very easy to read



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
