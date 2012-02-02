# -*- mode: sh; -*-

load_bg() {
    for x in "$@" ; do
        eval "$x() { command $x \"\$@\" & }"
    done
}

load_bg me
load_bg firefox pdkl_firefox
load_bg xpdf nautilus gimp q4wine
load_bg gmpc gqviewq

load_bg qjackctl jack-rack hydrogen seq24
load_bg qmidiarp qmidiroute

unset load_bg
