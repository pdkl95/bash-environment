if type -P dircolors >/dev/null ; then
    function load_dircolors {
        [ -r "$1" ] && eval $(dircolors -b "$1")
    }

    load_dircolors "/etc/DIR_COLORS"
	load_dircolors "${HOME}/.dir_colors"
	load_dircolors "${PDKL_BASHDIR}/dir_colors"

    unset load_dircolors
fi

##################################

add_path_prefix "$HOME/games/minecraft/bin"
add_path_prefix "$HOME/bin"

export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export LC_COLLATE="C"
export LC_CTYPE="C"

export EDITOR="vim"
export VISUAL="${EDITOR}"
export ALTERNATE_EDITOR=""

export PAGER=/usr/bin/less

export LESSCOLOR=yes
#export LESSOPEN='|lesspipe.sh %s 2>&-'
#export LESS='-i -w  -z-4 -e -M -F -R --shift 5 -P%t?f%f :stdin .?pb%pb\%:?lbLine %lb:?bbByte %bb:-...'

export TIMEFORMAT=$'\nreal %3R\tuser %3U\tsys %3S\tpcpu %P\n'

export FIGNORE='.o:~'
export HISTFILE="${PDKL_BASHDIR}/history.list"
export HISTTIMEFORMAT="%H:%M > "
export HISTIGNORE="&:bg:fg:ll:h"
export HISTSIZE=2000

export RUBYOPT=""
#export GEM_HOME="$HOME/.gem"
#export GEM_PATH="$GEM_HOME:/usr/lib/ruby/gems/1.9.1"
#add_path_prefix "$HOME/.gem/bin"

#export GOROOT="$HOME/src/go"
#export GOOS="linux"
#export GOARCH="amd64"
#export GOBIN="$HOME/bin"



##################################################
# set some defaults

if [ -z "${MPLAYEROPT}" ] ; then
    export MPLAYEROPT="-profile m.vdpau.mild"
fi

if [ ${USE_ANSI_COLOR:-1} -eq 1 ] ; then
    export USE_ANSI_COLOR=1
else
    export USE_ANSI_COLOR=0
fi

if [ ${GRATUITOUS_MPLAYER_HELPER_OUTPUT:-1} -eq 1 ] ; then
    export GRATUITOUS_MPLAYER_HELPER_OUTPUT=1
else
    export GRATUITOUS_MPLAYER_HELPER_OUTPUT=0
fi
