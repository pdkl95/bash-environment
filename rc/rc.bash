#!/bin/bash
# -*- mode: sh -*-

# Shell is non-interactive?
[[ $- != *i* ]] && return

export TERM=xterm-256color

######################
###  Interactive!  ###
######################

# UGLY, but it works, and we can't abstract out anything
# until _init.bash gets loaded...
. "$( cd -P "$( dirname "$(readlink -f "${BASH_SOURCE[0]}")" )" && pwd )/../lib/_init.bash"

###############################################
###  setup the stanndard $HOME environment  ###
###############################################

add_path_prefix "${HOME}/node_modules/.bin"
add_path_prefix "${bashHOME}/bin"


#############################################
###  load the various modules as desired  ###
#############################################

load_bash_lib "options"
load_bash_lib "ansicolor"
load_bash_lib "helpers"
load_bash_lib "env"
load_bash_lib "editor"
load_bash_lib "util"
load_bash_lib "prompt"
load_bash_lib "aliases"
load_bash_lib "completion"

# any of these modules taht can be defered until later
# should be. The startup time is annoying enough...
defer_load_bash_lib "mplayer_helper" "m" "mm"


#EOF
