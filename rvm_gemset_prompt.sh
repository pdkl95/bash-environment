##################################
###  RVM gemset in the prompt  ###
##################################

function current_rvm_gemset {
    local ID="$(rvm tools identifier)"
    if [[ "$ID" = "$(rvm alias show default)" ]] ; then
        echo ''
    else
        echo ${ID//*@}
    fi
}

RVMPREFIX="${BLUE}<${cyan}\$(current_rvm_gemset)${BLUE}> "
PS1_BASIC="${green}\u${GREEN}@${green}\h${cyan} \w ${BLUE}\$${NC} "
PS1_GITSH='`_git_headname`!`_git_workdir``_git_dirty`> '
function set_rvm_color_prompt {
    if [ -n "$rvm_version" ] ; then
        local GS=$(current_rvm_gemset)

        if [ -n "$GS" ] ; then
            if [ "$(type -t gitalias)" ] ; then
                export PS1="$RVMPREFIX$PS1_GITSH"
            else
                export PS1="$RVMPREFIX$PS1_BASIC"
            fi
        else
            if [ "$(type -t gitalias)" ] ; then
                export PS1="$PS1_GITSH"
            else
                export PS1="$PS1_BASIC"
            fi
        fi
    fi
}

function set_xterm_title {
    case $TERM in
	xterm*|rxvt|Eterm|eterm|aterm|kterm|gnome*|interix)
		echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/$HOME/~}\007"
		;;
	screen)
		echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/$HOME/~}\033\\"
		;;
    esac
}

function custom_prompt_command {
    set_xterm_title
    set_rvm_color_prompt
}
