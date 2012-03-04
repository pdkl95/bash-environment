#!/bin/bash

tree_most_recent() {
    find !(manga) -type f -printf "%A@ %Am/%Ad %AH:%AM %p\n" | sort -n | cut -d' ' -f2-
}



fullenv() {
    for _a in {A..Z} {a..z} ; do
        _z=\${!${_a}*}
        for _i in `eval echo "${_z}"` ; do
            echo -e "$_i: ${!_i}"
        done
    done | /bin/cat -Tsv
}

ff() {
    find . -type f "$@"
}

# Repeat n times command.
# repeat() {
#     local i max
#     max=$1
#     shift
#     for ((i=1; i <= max ; i++)); do
#         eval "$@"
#     done
# }

my_ip_from_outsie_prespective() {
    curl ifconfig.me
}
#alias my_ip="my_ip_from_outside_prespective"




# Local Variables:
# mode: sh
# sh-basic-offset: 4
# sh-shell: bash
# coding: unix
# End:
