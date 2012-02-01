export INPUTRC="~/.inputrc"

add_path_prefix "${bashHOME}/games/minecraft/bin"
add_path_prefix "${bashHOME}/src/scripts/bin"

# let RBenv manager our rubies
add_path_prefix "${bashHOME}/.rbenv/bin"
eval "$(rbenv init -)"

# misc settings
export TIMEFORMAT=$'\nreal %3R\tuser %3U\tsys %3S\tpcpu %P\n'
export FIGNORE='.o:~'

# *** HACK ***
# Workaround for how Gentoo deals with ruygems. We manage it
# entirely separate from the distory anyway (rbenv/bundler), so this
# has little utility anyway.
export RUBYOPT=""
