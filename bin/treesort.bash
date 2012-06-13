#!/bin/bash

VERSION="1.0"
USAGE="\
usage: $0 [options] [<tree_root_directorory>]
Sorts all of the files in the names subtree at once.

$(extract_usage_options.bash "$0")
"

lsextra='--color --human-readable'
lsopt=''
diropt=''
sortkey='%T@'

while (( $# > 0 )) ; do
    case $1 in
# USEROPT+start
# Print this help
        -h | --help)    echo -e "$USAGE"    ;  exit 0 ;;
# Print the script version
        -V | --version) echo -e "$VERSION"  ;  exit 0 ;;

# show detailed (long) output
        -l | --long)    lsopt="-l"          ; shift   ;;
# pass params to 'ls'
        -L | --ls-opt)  lsopt="$2"          ; shfit 2 ;;

# print results in ascending order (default)
        -A | --asc)     diropt=''           ; shift   ;;
# print results in descending order
        -D | --desc)    diropt='-r'         ; shift   ;;
# shorthand for --desc
        -r | --reverse) diropt='-r'         ; shift   ;;

# sort on: size (default)
        -s | --size)    sortkey='%s'        ; shift   ;;
# sort on: mtime
        -m | --mtime)   sortkey='%T@'       ; shift   ;;
# sort on: mtime
        -a | --atime)   sortkey='%A@'       ; shift   ;;
# sort on: mtime
        -c | --ctime)   sortkey='%C@'       ; shift   ;;

# USEROPT+end
        --) shift ; break ;;
        -*) echo "bad opt: $1" ; exit 1 ;;
        *)  break ;;
    esac
done

FINDOPTS="-type f"

case $# in
    0) ROOT="." ;;
    1) ROOT="$1"   ;;
    *) echo "only one tree-root at a time!" 1>&2 ; exit 1 ;;
esac

lsformat() {
    while read file ; do
        ls --directory ${lsextra} ${lsopt} "$file"
    done
}

fix_line_fmt() {
    sed -re 's/^\S+\s+//g'
}

sort_tree() {
    sort -n ${diropt}
}

list_tree_data() {
    find "${ROOT}" ${FINDOPTS} -printf "${sortkey} %p\n"
}

list_tree() {
    list_tree_data | sort_tree | fix_line_fmt | lsformat
}

list_tree


# Local Variables:
# mode: sh
# sh-basic-offset: 4
# sh-shell: bash
# coding: unix
# End:
