##################################################
# PROMPT
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
    CSTATUS="$(prompt_cmdstatus $EVAL)"
    WHOAMI="$(prompt_whoami)"
    PDIR="$(prompt_pwd)"
    MARK="$(prompt_mark)"

    xtitle "$CSTATUS ${PWD/$HOME/~}"
    export PS1="$WHOAMI $PDIR $MARK "
}

PROMPT_COMMAND="print_current_prompt"
export PS1="\u@\h \w \$ "
