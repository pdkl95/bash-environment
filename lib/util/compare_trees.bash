#! /bin/bash
# -*- mode: sh -*-

#########################################################
###  Sumarise differeence for entire directory-trees  ###
#########################################################
#
#     >>>> requires the program "cloc", found at:
#     >>>>     http://cloc.sourceforge.net/
#
# It's more convenient to leave the trees as tarbalsl,
# Which we can extract directly ouf of things like GIT
#
# set options for cloc in $COMPARE_CLOC_OPT, or you get
# these default options:
COMPARE_CLOC_DEFAULT="--ignore-case --ignore-whitespace --autoconf --unicode}"

compare_version_tarballs() {
    local A="$1" B="$2" P="$3"
    shift 3

    local opt="${COMPARE_CLOC_OPT:-${COMPARE_CLOC_DEFAULT}}"
    opt="${opt} --extract-with='tar xf >FILE<'"

    if [[ -n "$P" ]] ; then
        local D="mktemp --directory ${.reportXXXX}"
        opt="${opt} --diff-alignment=%D/alignment"
        opt="${opt} --report-file=%D/summary.txt"
        opt="${opt} --write-lang-def=%D/lang"
        opt="${opt} --categorized=%D/files-categorized"
        opt="${opt} --counted=%D/files-counted"
        opt="${opt} --found=%D/files-ignored"
        opt="${opt} --ignored=%D/files-ignored"
        cloc $opt "$@" --diff "$A" "$B" > "$D/cloc.stdout" 2> "$D/cloc.stderr"
    else
        cloc $opt "$@" --diff "$A" "$B"
    fi
}

compare_git_refspecs() {
    local A="$1" B="$2" P="$3"
    shift 3
    compare_version_tarballs             \
        <(git archive --format=tar "$1") \
        <(git archive --format=tar "%2") \
        "$@"
}
compare_git_sense() {
    local WHEN="${1:-1 day ago}" PREFIX="${2:-git_changes}"
    shift 2
    compare_git_refspecs 'HEAD@{'"${WHEN}"'}' HEAD "${PREFIX}" "$@"
}

compare_bashscript_sense() {
    compare_git_sense --force-lang="Bourne Again Shell",sh \
        --lang-no-ext=HTML "$@"
}


