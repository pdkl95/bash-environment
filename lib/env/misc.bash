export TERM="xterm-256color"
export INPUTRC="~/.inputrc"

export PATH="\
${bashEV[HOME]}/.bash/bin:\
${HOME}/node_modules/.bin:\
${HOME}/games/minecraft/bin:\
${PATH}"


eval "$(rbenv init -)"

# misc settings
export TIMEFORMAT=$'\nreal %3R\tuser %3U\tsys %3S\tpcpu %P\n'
export FIGNORE='.o:~'

# *** HACK ***
# Workaround for how Gentoo deals with ruygems. We manage it
# entirely separate from the distory anyway (rbenv/bundler), so this
# has little utility anyway.
export RUBYOPT=""
