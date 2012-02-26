#! /bin/bash
# -*- mode: sh -*-

#################
###  History  ###
#################

# where save it
export HISTFILE="${bashEV[ROOT]}/history.list"

# HUGE history file! why not, we have the disk...
export HISTSIZE=100000
export HISTFILESIZE=100000

# ALLOWING dupes, again because disk is basically free
# it wil allow for some interesting statistics to be generated
# aft some time, as a bonus...
export HISTCONTROL=" ignorespace"
# these are SO generic, though, that we suould it's stil
# worth filtering them (notable exceptio: cd and ls are
# logged!) or just useless
export HISTIGNORE="bg:fg::m:mm:mplayer:mplayer2:top:clear:exit"

# make the output look nicer than timestaps (see: "man strftime")
#export HISTIMEFORMAT='%Y-%b-%d %k:%M'
export HISTTIMEFORMAT='%b-%d %k:%M | '
#(the year seems overkill)
