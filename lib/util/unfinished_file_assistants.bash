#! /bin/bash
# -*- mode: sh -*-

bad_symlinks() {
    local ARG="$@"
    [[ -n $ARG ]] || ARG="$PWD"

    find -L "$ARG" -type l
}

# Swap 2 filenames around, if they exist
swap() {
    local TMPFILE=tmp.$$

    [ $# -ne 2 ] && echo "swap: 2 arguments needed" && return 1
    [  ! -e $1 ] && echo "swap: $1 does not exist"  && return 1
    [  ! -e $2 ] && echo "swap: $2 does not exist"  && return 1

    mv "$1" $TMPFILE
    mv "$2" "$1"
    mv $TMPFILE "$2"
}


# as imple 'diff' across all the files in two directories
# (xxdiff might be nicer, though...)
dircmp() {
    diff -qrsl $1 $2 | sort -r | \
        awk '/differ/ {
           print "different  ",$2;
         }
         /are identical/ {
           print "same       ",$2;
         }
         /Only in/ {
           print $0;
         }'
}


########################################
# eXpand File shortcuts and protection #
########################################

# just assign the apropriate tool
# to the given filetype
xf_run_decompressor() {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xvjf $1     ;;
            *.tar.gz)    tar xvzf $1     ;;
            *.bz2)       bunzip2 $1      ;;
            *.rar)       rar x $1        ;;
            *.gz)        gunzip $1       ;;
            *.tar)       tar xvf $1      ;;
            *.tbz2)      tar xvjf $1     ;;
            *.tgz)       tar xvzf $1     ;;
            *.zip)       unzip $1        ;;
            *.Z)         uncompress $1   ;;
            *.7z)        7z x $1         ;;
            *)           echo "'$1' cannot be extracted via >extract<" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# protect ex from expanding anything but a single subdir
# into the *current* directory, by wrapping it in
# in an outer shield initially
xf() {
    local Z="$1"
    local name="${Z%%.*}"
    echo "$name"

    ZPATH="$(readlink -f "$Z")"
    [[ -r "$ZPATH" ]] || fatal "Cannot read: ${ZPATH}"

    # we can only proceed if the extracted
    # name actualy existed
    [[ -z "$name" ]] && fatal "Could not parse the \"${Z}\" as an archive name!"

    # first, assume we can use that name as the
    # wrap-dir name like normal
    local TMPDIR="$(mktemp --directory "${name}"--XF-wrapper-XXXXXXXX )"
    [[ -d "${TMPDIR}" ]] || fatal "kmtempdid not make our tempdir?!"

    local start_dir="$PWD"
    cd "${TMPDIR}" || fatal "error changing directory to the temp-dir"

    # actually expand the archive!
    xf_run_decompressor "${ZPATH}" || fatal "decompression fail!"

    # see if we can move the result to their proper location
    local coun="$(find . -maxdepth 1 | wc -l)"
    if [[ "1" -eq "$count" ]] ; then
        local result="$(find . -maxdepth 1 | grep -v '^.$')"
        echo ">>> GOOD! The archive only had a single item in it!"
        cd "$start_dir" || fatal "Error returnign to: $start_dir"

        if [[ -e "$result" ]] ; then
            echo "... but the name was already taken at the top-level."
        else
            echo ">>> GOOD! No local name collision!"
            mv "$TMPDIR/$result" .
            if rmdir "$TMPDIR" ; then
                echo "\
??? inconsistent behavior...?

wait, we failed to remove the tempdir after moving
what was *supposedly* a single file. You should check
thiings out in \"${TMPDIR}/\" to see what happened
"
            else
                echo "\
>>> All done. things shold be thhe same as if you had
>>> extracted the file yourself in the current directory
"
            fi
        fi
    else
        echo "\
*** STUPID FILE WARNINNG! ***
Looks like the file left $count files in the temp dir.
Look for the mess in:
    ${TMPDIR}
"
    fi
    return 0
}
