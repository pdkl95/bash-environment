##################################################
# PROMPT

PCMD_BASIC='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/$HOME/~}\033\\"'
PCMD_COLOR='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/$HOME/~}\007"'
if type -t custom_prompt_command > /dev/null ; then
    PCMD_FANCY='custom_prompt_command'
else
    PCMD_FANCY="${PCMD_COLOR}"
fi

if [[ -z "${LS_COLORS}" ]] ; then
    ###  NO COLOR  ###
    PROMPT_COMMAND="${PCMD_BASIC}"
	if [[ ${EUID} == 0 ]] ; then
		# show root@ when we don't have colors
		PS1='\u@\h \W \$ '
	else
		PS1='\u@\h \w \$ '
	fi
else
    case ${TERM} in
    xterm*|rxvt*)             PROMPT_COMMAND="${PCMD_FANCY}" ;;
    Eterm|aterm|kterm|gnome*) PROMPT_COMMAND="${PCMD_COLOR}" ;;
    screen)                   PROMPT_COMMAND="${PCMD_BASIC}" ;;
    esac

    ###  COLOR IS ON  ###
    if [[ ${EUID} == 0 ]] ; then
	    PS1='\[\033[01;31m\]\h\[\033[01;34m\] \W \$\[\033[00m\] '
    else
	    PS1='\[\033[01;32m\]\u@\h\[\033[01;34m\] \w \$\[\033[00m\] '
    fi
fi
export PROMPT_COMMAND PS1
unset PCMD_BASIC PCMD_COLOR PCMD_FANCY
