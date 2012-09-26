# -*- mode: sh -*-

# rst() {
#     case _$(type -t "$1") in
#         _alias)  unalias "$1" ;;
#         _function) unset "$1" ;;
#     esac
# }

# awrap() {
#     local X="$1" ; shift
#     if is_cmd $X ; then
#         rst $X
#         alias _pdkl_$X="command $X $@"
#     else
#         alias _pdkl_$X="noop"
#     fi
# }

###################################################
## OPTIONAL COLOR AND OTHER FOUNDATIONAL MACROS

if [[ "${TERM}" =~ color ]] ; then
    alias _pdkl_ls="command ls --human-readable --color=auto"
    alias _pdkl_grep="command grep --extended-regexp --color=auto"
    if is_cmd grc ; then
        alias _pdkl_diff="command grc diff"
    else
        alias _pdkl_diff="command diff"
    fi
else
    alias _pdkl_ls="command ls --human-readable --color=auto"
    alias _pdkl_grep="command grep --extended-regexp"
    alias _pdkl_diff="command diff"
fi

###################################################
## General Aliases

alias env='command env | sort'
alias lspath='echo -e ${PATH//:/\\n}'
alias lsldpath='echo -e ${LD_LIBRARY_PATH//:/\\n}'
alias lsinfopath='echo -e ${INFOPATH//:/\\n}'
alias lsmanpath='echo -e ${MANPATH//:/\\n}'


alias jl="joblist"
alias toilet="command toilet -d ${HOME}/.cw/fonts"

alias d="display"
alias z="zile"
alias n="nano"

# destructive things should always be verbose
alias rm='command rm -v'
alias ln="command ln -v"
alias chmod='command chmod -c'

alias ret='cd "$OLDPWD"'

alias ls="_pdkl_ls"
alias ll="_pdkl_ls -l"             # maybe most commonn shorthand
alias la='ll --almost-all'         # show hidden, skip . and ..
alias lx='ll -X --ignore-backups'  # ort by extension, ignoring traling ~
alias lk='ll -S  --reverse'        # sort by file size, biggest last
alias lc='ll -tc --reverse'        # sort by CTIME, most recent last
alias lu='ll -tu --reverse'        # sort by ATIME, most recent last
alias lt='ll -t  --reverse'        # sort by MTIME, most recent last
# special shortcut for the one I use the most
alias l="lt"
# treat this like an 'ls' of sorts
alias lh="command du -khs * | sort -h"

# like an "ls", bu use stat to sort by file perms (octal)
alias lperm="stat -c %a\ %N\ %G\ %U \${PWD}/*|sort"
if is_cmd tree ; then
    alias tree='command tree -CAh'
else
    alias tree="command ls -FR"
fi
alias pstree='pstree -U'

alias iftop='xtitle Network Activity on eth1; sudo iftop -i eth1 -P'
alias  htop='xtitle Processes on $HOST ; sudo htop'
alias  _top='xtitle Processes on $HOST ;  top'
alias   top="htop"

alias make='xtitle Making $(basename $PWD) ; make'

alias more="less"
is_cmd which || alias which="command type -path"

alias    ..="cd .."
alias   ...='cd ../..'
alias  ....='cd ../../..'
alias .....='cd ../../../..'

alias free="free -m"
alias du="command du -kh"
alias df="command df -kTh"
alias diff2col="command diff --side-by-side --ignore-all-space"
alias diff='_pdkl_diff -up'
alias diffw="_pdkl_diff -u --ignore-all-space"

alias igrep="_pdkl_grep --ignore-case"
alias vgrep="_pdkl_grep --invert-match"
alias ivgrep="_pdkl_grep --ignore-case --invert-match"
alias gr="igrep"


[[ "$UNAME" != "Linux" ]] && is_cmd gsed && alias sed='gsed'

alias g="git"
alias gg="git status"
alias gitlog="git --no-pager log --oneline --graph -n 18 --decorate"

alias irb="command irb --readline"
is_cmd nautilus   && alias nautilus="command nautilus --no-desktop"
is_cmd mediainfo  && alias    mi="mediainfo"
is_cmd mkvmerge   && alias   mii="mkvmerge --identify-verbose"
is_cmd h264enc    && alias    h2="h264enc -2p -p slow -pf high"
is_cmd mpc        && alias   mpc="command mpc -h 127.0.0.1"
is_cmd pwgen      && alias pwgen="command pwgen -v -n"
is_cmd fixnames   && alias    fn="command fixnames -vvM"

if is_cmd atool ; then
    alias xx="command atool -x"
    alias xl="command atool -l"
fi

if is_cmd strace ; then
    alias strace="command strace-color"
    alias strace-file="strace -e trace=file"
fi

#unset awrap rst

# Local Variables:
# mode: sh
# sh-basic-offset: 4
# sh-shell: bash
# coding: unix
# End:
