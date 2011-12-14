# -*- mode: sh -*-

alias ret="cd \"$OLDPWD\""

alias ls="ls -hF ${AUTOCOLOR}"
alias la='ls -lA'          # show hidden files
alias lx='ls -lXB'         # sort by extension
alias lk='ls -lSr'         # sort by size, biggest last
alias lc='ls -ltcr'        # sort by and show change time, most recent last
alias lu='ls -ltur'        # sort by and show access time, most recent last
alias lt='ls -ltr'         # sort by date, most recent last
alias lm='ls -al |more'    # pipe through 'more'
alias lr='ls -lR'          # recursive ls

alias l="lt"
alias lll="stat -c %a\ %N\ %G\ %U \${PWD}/*|sort"
if is_cmd tree ; then
    alias tree='commmand tree -CAh'
else
    alias tree="command ls -FR"
fi

alias top='xtitle Processes on $HOST && top'
alias make='xtitle Making $(basename $PWD) ; make'

alias more="less"
alias j="jobs -l"
is_cmd which || alias which="command type -path"
alias ..="cd .."
alias ...="cd .."
alias path='echo -e ${PATH//:/\\n)'
alias libpath='echo -e ${LD_LIBRARY_PATH//:/\\n}'
alias du="command du -kh"
alias df="command df -kTh"
alias grep='grep --color=auto'

alias diff='diff -up'
is_cmd colordiff && alias diff='colordiff -up'
[[ "$UNAME" != "Linux" ]] && is_cmd gsed && alias sed='gsed'
is_cmd ionice && is_cmd nice && alias inice='ionice -c3 -n7 nice'
is_cmd ccze && alias lessc='ccze -A |`type -P less` -R'

alias chmod='command chmod -c'
alias rm='command rm -v'
alias cp='command cp -v'
alias mv="command mv -v"
alias ln="command ln -v"


#alias rscp="rsync --partial --progress --append --rsh=ssh -r -h "
#alias rsmv="rsync --partial --progress --append --rsh=ssh -r -h --remove-sent-files"

alias nano="command nano -w"
alias nn=nano
alias env='command env | sort'

alias irb="irb --readline -r irb/completion"
alias nautilus="nautilus --no-desktop"

#is_cmd mpc && alias mpc="mpc -h 10.0.0.200"
is_cmd pwgen && alias pwgen="command pwgen -v -n"
is_cmd fixnames && alias fn="command fixnames -fvv"
is_cmd youtube-dl && alias yt="command youtube-dl -t -c --format 38/37/45/22/44/35/34/18/6/5/17/13"


alias pp="my_ps_tree"
alias ppw="my_ps_tree_wide"

alias g="git"
alias gg="git status"
alias be="bundle exec"
alias bake="bundle exec rake"
alias rc="bake rails c"
alias rg="bake rails g"
alias rdb="bake rails db"
alias glog="git --no-pager log --oneline --graph -n 18 --decorate"

alias lT="list_tree_mtime_asc"
alias lTr="list_tree_mtime_desc"
alias lS="list_tree_size_asc"
alias lSr="list_tree_size_desc"
