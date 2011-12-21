# various project-wide directory roots
export PDKL_SCRIPT_ROOT="${PDKL_HOME}/src/scripts"
export MINECRAFT_ROOT="${PDKL_HOME}/games/minecraft"

add_project_root "${PDKL_SCRIPT_ROOT}"
add_project_root "${MINECRAFT_ROOT}"

##########################################
# select an editor fin order of preference

select_prefered_editor() {
    for e in "zile" "emacs" "nano" "vim" "vi" ; do
        if is_cmd $e ; then
            export EDITOR="$e"
            return
        fi
    done
    # bad, none were found!
    echoerr "WARNING: no suitable choice for $EDITOR could be found!"
    echoerr "!!!!!!!! Falling ack the exing EDITOR=$EDITOR"
}
select_prefered_editor
export VISUAL="${EDITOR}"

##############
# Locales/i18n
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export LC_COLLATE="C"
export LC_CTYPE="C"


##################################################
# set some defaults

if is_cmd less ; then
    export PAGER=less
    if $USE_ANSI_COLOR ; then
        # if is_cmd lesspipe ; then
        #     # Less Colors for Man Pages
        #     export LESS_TERMCAP_mb=$'\E[01;31m'       # begin blinking
        #     export LESS_TERMCAP_md=$'\E[01;38;5;74m'  # begin bold
        #     export LESS_TERMCAP_me=$'\E[0m'           # end mode
        #     export LESS_TERMCAP_se=$'\E[0m'           # end stdout-mode
        #     export LESS_TERMCAP_so=$'\E[38;5;246m'    # begin stdout-mode - infobox
        #     export LESS_TERMCAP_ue=$'\E[0m'           # end underline
        #     export LESS_TERMCAP_us=$'\E[04;38;5;146m' # begin underline
        #     export LESSCHARSET='latin1'
        #     export LESSOPEN='|gzip -cdfq %s | `type -P lesspipe` %s 2>&-'
        #     export LESS='-i -N -w  -z-4 -e -M -X -J -s -R -P%t?f%f :stdin .?pb%pb\%:?lbLine %lb:?bbByte %bb:-...'
        # else

        # for now, ignore this LESS customization.
        # it needs a lot of work
            export LESSCOLOR=yes
        #fi
    fi
else
    export PAGER=more
fi

export TIMEFORMAT=$'\nreal %3R\tuser %3U\tsys %3S\tpcpu %P\n'
export FIGNORE='.o:~'

# huge history, shared across all bashes. sync it in PROMPT_COMMAND by
# calling "history -a" at a minimum
export HISTCONTROL="erasedups"
export HISTFILE="${PDKL_BASHDIR}/history.list"
export HISTSIZE=100000
export HISTFILESIZE=100000
export HISTIGNORE="&:bg:fg:lt:h:m:mm:mplayer:mplayer2:top:clear:exit"
unset HISTTIMEFORMAT

# *** HACK ***
# Workaround for how Gentoo deals with ruygems. We manage it
# entirely separate from the distory anyway (rvm/bundler), so this
# has little utility anyway.
export RUBYOPT=""
