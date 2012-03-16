#!/bin/bash

if [[ $# -lt 1 ]] ; then 
    echo "usage: $0 <script_with_USEROPT_block>"
    exit -1
fi

echo "COMMANDS:"
cat "$1" | sed -nre "\
/USEROPT\Wstart/,/USEROPT\Wend/ {
s/^\s*//
s/\).*;;//
s/^# USEROPT.*$//
s/^-/        -/
s/# /    /
p
}"


# Local Variables:
# mode: sh
# sh-basic-offset: 4
# sh-shell: bash
# coding: unix
# End:
