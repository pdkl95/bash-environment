# -*- mode: sh; -*-
return
load_bg() {
    for x in "$@" ; do
        eval "$x() { command $x \"\$@\" & }"
    done
}

load_bg me
load_bg firefox pdkl_firefox
load_bg google-chrome opera
load_bg epdfview gimp gmpc geeqie
load_bg nautilus q4wine
load_bg qjackctl jack-rack hydrogen seq24
load_bg qmidiarp qmidiroute

unset load_bg
