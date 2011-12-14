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

setup_history() {
    export HISTCONTROL=${HISTCONTROL:-'ignoreboth'};
    export HISTFILE="${PDKL_BASHDIR}/history.list"
    export HISTSIZE=500
    export HISTFILESIZE=2000
    export HISTIGNORE="&:bg:fg:ll:h:top:clear:exit"

    unset HISTTIMEFORMAT

    HISTFILEMASTER_DIR="${PDKL_BASHDIR}/history.d"
    [[ ! -d "$HISTFILEMASTER_DIR/" ]] && mkdir -pv "$HISTFILEMASTER_DIR"

    # if no readable HISTFILE then create one with current history
    [[ ! -r "${HISTFILE}" ]] && history -w "$HISTFILE"

    # if no HISTFILEMASTER then create one with current history
    HISTFILEMASTER="${HISTFILEMASTER_DIR}/combined.log"
    [[ ! -f "$HISTFILEMASTER" ]] && history -r && history -w "$HISTFILEMASTER" && history -&& echo "" > "$HISTFILE"
    export HISTFILEMASTER

    HISTFILEMASTER_C="$HISTFILEMASTER_DIR/combined-uniq.log"
    [[ ! -f "$HISTFILEMASTER_C" ]] && echo "" > "$HISTFILEMASTER_C"
    export HISTFILEMASTER_C
}

histfilemaster() {
    set -vx;
    history -a
    [[ "`wc -l < $HISTFILE`" -gt "$HISTSIZE" ]] && (
        cat $HISTFILE >> $HISTFILEMASTER
        cat $HISTFILE > `date +$HISTFILEMASTER_DIR/%m-%d-%y.history`
        cat $HISTFILE $HISTFILEMASTER_C | sort | uniq > $HISTFILEMASTER_DIR/hc.tmp
        [[ "$(wc -l < $HISTFILEMASTER_DIR/hc.tmp)" -gt "$(wc -l < $HISTFILEMASTER_C)" ]] && mv $HISTFILEMASTER_DIR/hc.tmp $HISTFILEMASTER_C || cat $HISTFILE >> $HISTFILEMASTER_C;
        echo "" > $HISTFILE
    )
    set +vx;
}


uniqhistory() {
    ( echo $HISTFILE; find $HISTFILEMASTER_DIR -type f 2>$N6 ) | xargs -iFFF cat FFF 2>$N6 | sed -e 's/^[ \t]*//;s/[ \t]*$//' -e '/[^ \t]\{1,\}/!d' | tr --squeeze ' ' | sort -u
}

savehist() {
    history ${HISTCMD:-5000} | sed -e 's/^[ 0-9]*\(.*\)/\1/g' | tee -a $HISTFILEMASTER_C >> $HISTFILEMASTER
    cat $HISTFILE | tee -a $HISTFILEMASTER_C >> $HISTFILEMASTER
    history -w
    echo
}

h1() {
    [[ "$#" -lt "1" ]] && echo "Usage: $FUNCNAME query" >&2 && return 2
    command grep -h -i "$@" $HISTFILEMASTER
}


h1c() {
    [[ "$#" -lt "1" ]] && echo "Usage: $FUNCNAME query" >&2 && return 2
    command grep --color=always -h -i "$@" $HISTFILEMASTER
}

h2() {
    [[ "$#" -lt "1" ]] && echo "Usage: $FUNCNAME query" >&2 && return 2
    command grep -h "$@" $HISTFILEMASTER_C
}
h2i() {
    [[ "$#" -lt "1" ]] && echo "Usage: $FUNCNAME query" >&2 && return 2
    command grep -h -i "$@" $HISTFILEMASTER_C
}
h2c() {
    [[ "$#" -lt "1" ]] && echo "Usage: $FUNCNAME query" >&2 && return 2
    export GREP_COLOR=`echo -en "\e[1;3$(( $RANDOM % 7 + 1 ))"`
    command grep --color=always -h "$@" $HISTFILEMASTER_C
}

hpopular() {
  cat $HISTFILEMASTER | awk '{print $2}' | sort | uniq -c | sort -rn | head -n ${1:-50};
}
setup_history

# *** HACK ***
# Workaround for how Gentoo deals with ruygems. We manage it
# entirely separate from the distory anyway (rvm/bundler), so this
# has little utility anyway.
export RUBYOPT=""
