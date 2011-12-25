##################################################
# PROMPT
_gitsh_is_active() {
    [ "$(type -t gitalias)" ]
}
_gitsh_cur_branch() {
    local br=`git symbolic-ref -q HEAD 2>/dev/null`;
    [ -n "$br" ] && br=${br#refs/heads/} || br=`git rev-parse --short HEAD 2>/dev/null`;
    echo "$br"
}


prompt_whoami() {
    echo -ne "\[${CCgreen}\]${USER}"
    echo -ne "\[${CCBgreen}\]@"
    echo -ne "\[${CCgreen}\]${HOSTNAME}"
}

prompt_pwd() {
    echo -ne "\[${CCcyan}\]${PWD/$HOME/~}"
}
prompt_mark() {
    echo -ne "\[${CCblue}\]\$"
    echo -ne "\[${CCnil}\]"
}

prompt_cmdstatus() {
    local S fst=true EVAL="$1"
    if [[ "${EVAL}" -eq 0 ]] ; then
        echo "    "
        #echo "····"
        #echo "qqqq"
    else
        S="$EVAL»"

        while [[ "${#S}" -lt 4 ]]; do
            if $fst ; then
                S="«${S}"
                fst=false
            else
                #S="·${S}"
                S="!${S}"
                #S=" ${S}"
            fi
        done
        echo "$S"
    fi
}

print_current_prompt() {
    local EVAL="$?" CSTATUS WHOAMI PDIR MARK

    history -a
    #history -n

    CSTATUS="$(prompt_cmdstatus $EVAL)"
    WHOAMI="$(prompt_whoami)"
    PDIR="$(prompt_pwd)"
    MARK="$(prompt_mark)"


    if _gitsh_is_active ; then
        xtitle "<$(_gitsh_cur_branch)> $CSTATUS ${PWD/$HOME/~}"
        # this has to be backticks, not $(), or bash munges up
        # the ANSI escape codes. probably a better way to do this...
        export PS1='`_git_headname`!`_git_workdir``_git_dirty`> '
    else
        xtitle "$CSTATUS ${PWD/$HOME/~}/"
        export PS1="$WHOAMI $PDIR $MARK "
    fi
}

PROMPT_COMMAND="print_current_prompt"
export PS1="\u@\h \w \$ "
