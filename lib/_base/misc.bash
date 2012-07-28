#!/bin/bash

: ${TERM:=xterm-256color}
: ${INPUTRC:=$HOME/.inputrc}

# ${bashEV[HOME]}/.bash/bin:
PATH="\
${HOME}/bin:\
${HOME}/bin/elf:\
${HOME}/.rbenv/shims:\
${HOME}/.cw/bin:\
${PATH}"

export TERM INPUTRC PATH


# guess color mode from the terminal name
# if it's not set already
if [[ "$TERM" =~ xterm ]] ; then
    TERM="xterm-256color"
fi

# Allow color-wrapper to work in non-pipe situations
NOCOLOR_PIPE=1

# 256 color support for grep!
GREP_COLORS="rv:mt=38;5;197;1:sl=48;5;234:cx=38;5;247:fn=38;5;039:ln=38;5;208:bn=38;5;227:se=48;5;017;38;5;57"

# etc
TIMEFORMAT=$'\nreal %3R\tuser %3U\tsys %3S\tpcpu %P\n'
FIGNORE='.o:~'

#export NOCOLOR_PIPE GREP_COLORS TIMEFORMAT FIGNORE

# *** HACK ***
# Workaround for how Gentoo deals with ruygems. We manage it
# entirely separate from the distory anyway (rbenv/bundler), so this
# has little utility anyway.
export RUBYOPT=""

# ruby gc tuning
export RUBY_HEAP_MIN_SLOTS=1000000
export RUBY_HEAP_SLOTS_INCREMENT=1000000
export RUBY_HEAP_SLOTS_GROWTH_FACTOR=1
export RUBY_GC_MALLOC_LIMIT=1000000000
export RUBY_HEAP_FREE_MIN=500000


# Local Variables:
# mode: sh
# sh-basic-offset: 4
# sh-shell: bash
# coding: unix
# End:
