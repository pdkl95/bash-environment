# -*- mode: sh -*-

# Shell is non-interactive?
[[ $- != *i* ]] && return


######################
###  Interactive!  ###
######################

# sandbox all the various bash stuff
export PDKL_BASHDIR="${HOME}/.bash"
function safe_load { [ -f "$1" ] && source "$1" ; }
function load_sh { safe_load "${PDKL_BASHDIR}/$1.sh" ; }

# all real work is done elsewhere
load_sh "options"
load_sh "env"
load_sh "ansicolor"
load_sh "mplayer_helper"
load_sh "rvm_gemset_prompt"
load_sh "functions"
load_sh "aliases"
load_sh "completion"

unset safe_load load_sh

