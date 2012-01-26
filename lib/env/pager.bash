#! /bin/bash
# -*- mode: sh -*-


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
