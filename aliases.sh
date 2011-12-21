alias ls="ls --color"
alias ll="ls -l"
alias lt="ll -tr"
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



