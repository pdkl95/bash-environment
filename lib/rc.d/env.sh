export INPUTRC="~/.inputrc"

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

###################################################
###  Locales (Internationalizatioo aka "i18n")  ###
###################################################

# never set this; it *OVERRIDES* *EVERYTHING*
# related to locales, often screwing up
# stuff that still depended on some specific
# (probably "C"/ASCII) property.
unset LC_ALL
# To set a default, instad use LANG which *NEVER*
# forces it';s value when there is something more speciic.
#
# Thhe default should almost always be a UTF-8
# variant if it exists. So uses your default value
# for as an input, but tries to upgrade the character
# set porttion if needed.
if [[ "${LANG:=en_US.utf8}" =~ '[[:lower:]]{2}(_[[:upper:]]{2}(\.[uU][tT][fF].?)?)?8$' ]] ; then
    :  # good - it amtches, no need to get invlived
else
    export LANG="$(locale -a | grep -i ^${LANG%%.*}.*\.utf8 | head -n 1)"
    if [[ -z "$LANG" ]] ; then
        echoerr "WARNING: Couldn't find a UTF8 compatible locsle! You should fix that or fix whatever is wrong with \$LANG/etc!"
    fi
fi


# default sort order to the ASCII-order sort that
# is still so common.
# but not recommended unless you kno how all the
: ${LC_COLLATE:=iso_8859.1}
#
# default to 1-octet-per-"charcter" strings as well
# as that affects the formating, layout, etc, of pretty
# much all formatting everywehere...
: ${LC_CTYPE:=iso_8859_1}
#
# <div class="rant">
#   <h3>fix your software!</h3>
#   There is no excuse for *ANY* # software to not
#   support UTF-8 straight. By default. Always.
#   <sidebar>
#     Iincidently, as a consequence of this, there is no
#     way to iterate over UTF-8, like people do frequently
#     with ascii. "One UNICODE CodePoint" is not a synonym
#     for "1 printable GLYPH", "Character", or "fixed amount"
#     of data (memory)." And in thoday's internet, the odds
#     of having to deal with asorted random areas of UNICODE
#     with strange properties is quickly approaching 1.0
#   </siebar>
# </div)
#
# The rese we leave alone... they either get overriden
# outside of this script, or they get the default $LANG value



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

# *** HACK ***
# Workaround for how Gentoo deals with ruygems. We manage it
# entirely separate from the distory anyway (rvm/bundler), so this
# has little utility anyway.
export RUBYOPT=""


#################
###  History  ###
#################

# where save it
export HISTFILE="${PDKL_BASHDIR}/var/history.list"

# HUGE history file! why not, we have the disk...
export HISTSIZE=100000
export HISTFILESIZE=100000

# ALLOWING dupes, again because disk is basically free
# it wil allow for some interesting statistics to be generated
# aft some time, as a bonus...
export HISTCONTROL=""
# these are SO generic, though, that we suould it's stil
# worth filtering them (notable exceptio: cd and ls are
# logged!) or just useless
export HISTIGNORE="bg:fg::m:mm:mplayer:mplayer2:top:clear:exit"

# make the output look nicer than timestaps (see: "man strftime")
#export HISTIMEFORMAT='%Y-%b-%d %k:%M'
export HISTIMEFORMAT='%b-%d %k:%M'
#(the year seems overkill)
