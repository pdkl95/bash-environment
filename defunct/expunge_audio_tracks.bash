#!/bin/bash

ex() {
    echo "EXEC: $@"
    "$@"
}

die() {
    echo "$@"
    dir_return
    exit 1
}

AUTO=false
MOVETO=

if [[ "$1" == "--auto" ]] && [[ -n "$2" ]]; then
    AUTO=true
    MOVETO="$2"
    shift 2
fi

echo "<$AUTO $MOVETO>"

[[ "$#" == "0" ]] && exit -1

exec_singleton() {
    if $AUTO ; then
        "$0" --auto "$MOVETO" "$@"
    else
        "$0" "$@"
    fi
}

if [[ "$#" == "1" ]] ; then
    echo "FIXING: $1"
else
    for i in "$@" ; do
        if ! exec_singleton "$i" ; then
            echo "Child returned error '$?'"
        fi
    done
    exit 0
fi

lang="jpn"
PLAY="mplayer2"

file="$1"
filebase="$(basename "$file")"
filedir="$(dirname "$file")"

dir_visit_target() {
    if [[ "$filedir" != "." ]] ; then
        echo "Moving to the tartget-file's directly"
        ex pushd "$filedir"
        file_orig="$file"
        file="$filebase"
    fi
}

dir_return() {
    if [[ "$filedir" != "." ]] ; then
        echo "*** Returning to our starting directory"
        ex popd
    fi
}

dir_visit_target

fixed="fixed-${file%.*}.mkv"

[[ -e "$file" ]] || die "No input at: ${file}"

atrack_count() {
    mkvmerge --identify "$1" | grep audio | wc -l
}
oldcount=$(atrack_count "$file")
[[ $pldcount -lt 2 ]] || die "no dual-audio (count=${oldcount})"
echo "Starting track count: ${oldcount}"

get_trackid() {
  mkvmerge --identify-verbose "$1" | egrep 'audio.*language:jpn' | sed -re 's/^Track\sID\s([[:digit:]]+):.*/\1/g'
}
tid="$(get_trackid "$file")"
if [[ "$tid" -lt "0" ]] ; then #|| [[ "$tid" -ge "$oldcount" ]] ; then
    die "bad TID=${tid}"
fi

keeptrack() {
    mkvmerge --identify-verbose "$file" | egrep "^Track ID ${tid}:"
}
echo
echo ">>>KEEPING TRACK>>> $(keeptrack)"
#echo ">>>EXPUNGING TRACK>>> $(deadtrack)"
echo

ex mkvmerge -o "$fixed" -a "${tid}" "$file"

newcount=$(atrack_count "$fixed")
if [[ $(($newcount + 1)) -eq $oldcount ]] ; then
    echo "good; exactly 1 track removed"
else
    die "ERROR: ORIG-track_count=${oldcount}, NEW-track_count=${newcount}"
fi

finish_auto() {
    echo "*** AUTO FINISH, BYPASSING VERIFICATION!!! ***"

}

finish_interactive() {
    echo "*** CHECK FOR ACCURACY! ***"
    ex ${PLAY} "$PWD/${fixed}"
    echo
    echo
    echo "*** Was it accurately converted? ***"
    echo "***   will REPLACE: $file"
    echo "***        -> with: $fixed"
    PS3="?> "
    select ans in \
        'Yes - *OVERWRITE* the original!' \
        ' No - Leave it all untouched'
    do
        case $REPLY in
            1) break ;;
            *) die "Exiting..."
        esac
    done
}

$AUTO && finish_auto || finish_interactive

if [[ -z "$MOVETO" ]] ; then
    ex mv -f "$fixed" "$file"
else
    if [[ "$MOVETO" == "." ]] ; then
        # same dir move doesn't make sense - treat this
        # case as "leavit it alone"
        echo "Targtet dir is \".\" - leaving things were they are"
    else
        ex mv -n "$fixed" "$MOVETO"
    fi
fi

dir_return

exit 0
