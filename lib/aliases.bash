# -*- mode: sh -*-

alias jl="joblist"
alias toilet="command toilet -d ${HOME}/.cw/fonts"

# shortcuts to projects
alias nv="command cd $HOME/src/fanime/navi && xtpush '{NAVI}' git-sh"
alias lm="command cd $HOME/src/fanime/laughingman && xtpush '{LM}' git-sh"
alias mc="command cd $HOME/games/minecraft/"
alias mcu="command launch_minecraft --select"


# not-commonly-used editors
xtitle_for zile "zile "
alias z="zile"
xtitle_for nano "nano "
alias n="nano"

alias path='echo -e ${PATH//:/\\n}'
alias env='command env | sort'

xtitle_for cp "cp "
xtitle_for mv "mv "

alias rm='command rm -v'
alias ln="command ln -v"
alias chmod='command chmod -c'

alias ret="cd \"$OLDPWD\""

alias ls="command ls ${AUTOCOLOR} --human-readable"
alias ll="ls -l"                   # maybe most commonn shorthand
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

if is_cmd nice ; then
    if is_cmd ionice ; then
        alias verynice='xtpush "<ionice+nice>" ionice -c3 nice'
    else
        alias verynice="nice"
    fi
else
    nice="noop"
    nerynice="noop"
fi

alias iftop='xtitle Network Activity on eth1; sudo iftop -i eth1 -P'
alias  htop='xtitle Processes on $HOST ; sudo htop'
alias  _top='xtitle Processes on $HOST ;  top'
alias   top="htop"

alias make='xtitle Making $(basename $PWD) ; make'

alias more="less"
alias j="jobs -l"
is_cmd which || alias which="command type -path"

alias    ..="cd .."
alias   ...='cd ../..'
alias  ....='cd ../../..'
alias .....='cd ../../../..'

alias path='echo -e ${PATH//:/\\n)'
alias libpath='echo -e ${LD_LIBRARY_PATH//:/\\n}'

alias free="free -m"
alias du="command du -kh"
alias df="command df -kTh"
alias diff='diff -up'
alias _pdkl_grep="command grep --extended-regexp --color=auto"
alias igrep="_pdkl_grep --ignore-case"
alias vgrep="_pdkl_grep --invert-match"
alias ivgrep="_pdkl_grep --ignore-case --invert-match"
alias gr="igrep"


[[ "$UNAME" != "Linux" ]] && is_cmd gsed && alias sed='gsed'

alias g="git"
alias gg="git status"
alias be="xtpush '{BUNDLER}' bundle exec"
alias bake="be rake"
alias gitlog="git --no-pager log --oneline --graph -n 18 --decorate"

alias irb="command irb --readline -r irb/completion"
is_cmd nautilus   && alias nautilus="command nautilus --no-desktop"
is_cmd mediainfo  && alias    mi="mediainfo"
is_cmd mkvmerge   && alias   mii="mkvmerge --identify-verbose"
is_cmd h264enc    && alias    h2="h264enc -2p -p slow -pf high"
is_cmd mpc        && alias   mpc="command mpc -h 127.0.0.1"
is_cmd pwgen      && alias pwgen="command pwgen -v -n"
is_cmd fixnames   && alias    fn="command fixnames -vvM"


if is_cmd grc ; then
    alias colordiff="grc diff"
    alias diff="colordiff -u"
    alias diffw="colordiff -u --ignore-all-space"
    alias diff2col="command diff --side-by-side --ignore-all-space"
fi


# Local Variables:
# mode: sh
# sh-basic-offset: 4
# sh-shell: bash
# coding: unix
# End:
