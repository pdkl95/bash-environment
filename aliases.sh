# -*- mode: sh -*-

# first and most important: editors
alias z="command zile"
alias nano="command nano -w"
alias n="nano"

alias E="emacs_eval"
alias e="emacs_frame_nowait"
alias et="emacs_tty"

# trap emacs itself so it goes through
# the emacsclient wrapper
alias emacs="emacs_frame_wait"
# trap random calls to "emacsclient", so
# can enforce specific options
alias emacsclient="emacs_form_wait"
# and for good measure...
alias xemacs="emacs_frame_wait"


alias env='command env | sort'

# try and help with safety; less annoying than -i
alias chmod='command chmod -c'
alias rm='command rm -v'
alias cp='command cp -v'
alias mv="command mv -v"
alias ln="command ln -v"

alias lm="command cd $HOME/src/fanime/laughingman && command git sh"

alias ret="cd \"$OLDPWD\""

alias ls="command ls ${AUTOCOLOR}"
alias ll="ls -l --human-readable"  # make the long format easier to read
alias la='ll --almost-all'         # show hidden, skip . and ..
alias lx='ll -X --ignore-backups'  # ort by extension, ignoring traling ~
alias lk='ll -S  --reverse'        # sort by file size, biggest last
alias lc='ll -tc --reverse'        # sort by CTIME, most recent last
alias lu='ll -tu --reverse'        # sort by ATIME, most recent last
alias lt='ll -t  --reverse'        # sort by MTIME, most recent last

# special shortcut for the one I use the most
alias l="lt"

# like an "ls", bu use stat to sort by file perms (octal)
alias lll="stat -c %a\ %N\ %G\ %U \${PWD}/*|sort"
if is_cmd tree ; then
    alias tree='command tree -CAh'
else
    alias tree="command ls -FR"
fi

alias top='xtitle Processes on $HOST && top'
alias make='xtitle Making $(basename $PWD) ; make'

alias more="less"
alias j="jobs -l"
is_cmd which || alias which="command type -path"

alias ..="cd .."
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

alias path='echo -e ${PATH//:/\\n)'
alias libpath='echo -e ${LD_LIBRARY_PATH//:/\\n}'

alias free="free -m"
alias du="command du -kh"
alias df="command df -kTh"
alias grep='grep --color=auto'

alias diff='diff -up'
is_cmd colordiff && alias diff='colordiff -up'
[[ "$UNAME" != "Linux" ]] && is_cmd gsed && alias sed='gsed'

alias g="git"
alias gg="git status"
alias be="bundle exec"
alias bake="bundle exec rake"
alias gitlog="git --no-pager log --oneline --graph -n 18 --decorate"



