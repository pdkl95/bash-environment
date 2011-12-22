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
is_cmd ionice && is_cmd nice && alias inice='ionice -c3 -n7 nice'
is_cmd ccze && alias lessc='ccze -A |`type -P less` -R'

alias irb="command irb --readline -r irb/completion"
alias nautilus="command nautilus --no-desktop"

#is_cmd mpc && alias mpc="mpc -h 10.0.0.200"
is_cmd pwgen && alias pwgen="command pwgen -v -n"
is_cmd fixnames && alias fn="command fixnames -fvv"
is_cmd youtube-dl && alias yt="command youtube-dl -t -c --format 38/37/45/22/44/35/34/18/6/5/17/13"

# pseudo 'pstree' from ps; has more info
alias pp="my_ps_tree"
alias ppw="my_ps_tree ww"
# also, fixup the actual "pstree" (requires wide output, but
# can be very easy to read
alias pstree="pstree -Gp"


alias g="git"
alias gg="git status"
alias be="bundle exec"
alias bake="bundle exec rake"
alias gitlog="git --no-pager log --oneline --graph -n 18 --decorate"


alias lT="list_tree_mtime_asc"
alias lTr="list_tree_mtime_desc"
alias lS="list_tree_size_asc"
alias lSr="list_tree_size_desc"


#alias rscp="rsync --partial --progress --append --rsh=ssh -r -h "
#alias rsmv="rsync --partial --progress --append --rsh=ssh -r -h --remove-sent-files"
