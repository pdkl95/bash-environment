##################################################
# PROMPT

current_ruby_version() {
    local OPT="$1"
    local V=$(rbenv version-name)
    local T="$V"

    case ${V} in
        1.8.7-p???)    T='1.8.7' ;;
        1.9.3-p0-perf) T='1.9.3' ;;
    esac

    cmark() {
        case $T in
            1.9.3) echo 'D' ;;  # 'D'efault
            1.8.7) echo 'S' ;;  # 'S'able legacy
            *)     echo '?' ;;
        esac
    }

    dmark() {
        case $T in
            1.9.3) echo ''   ;;  # EMPTY on 'Default'
            1.8.7) echo 'LM' ;;  # LaughingMan (fanime)
            *)     echo '??' ;;  # mark 'unknown' for others
        esac                     #
    }                            #   |
                                 #   V
    case "$OPT" in               #
        -c|--char)  cmark   ;;   #   |
        -d|--dmark) dmark   ;;   #   V
        -s|--short) echo $T ;;   #
        -l|--long)  echo $V ;;   # ..but falls back to
        *)          echo $V ;;   # version-strigs in the end
    esac
}


_gitsh_is_active() {
    [ "$(type -t gitalias)" ]
}
_gitsh_cur_branch() {
    local br=`git symbolic-ref -q HEAD 2>/dev/null`;
    [ -n "$br" ] && br=${br#refs/heads/} || br=`git rev-parse --short HEAD 2>/dev/null`;
    echo "$br"
}

if ${USE_ANSI_256COLOR} ; then
    prompt_whoami() {
        echo -ne "\[\e[38;5;28m\]${USER}"
        echo -ne "\[\e[38;5;40m\]@"
        echo -ne "\[\e[38;5;28m\]${HOSTNAME}"
    }
    prompt_pwd() {
        echo -ne "\[\e[38;5;44m\]${PWD/$HOME/~}"
    }
    prompt_mark() {
        echo -ne "\[\e[48;5;18;38;5;63m\]\$"
        echo -ne "\[\e[0m\]"
    }
else
    if ${USE_ANSI_COLOR} ; then
        prompt_whoami() {
            echo -ne "\[\e[32m\]${USER}"
            echo -ne "\[\e[92m\]@"
            echo -ne "\[\e[32m\]${HOSTNAME}"
        }
        prompt_pwd() {
            echo -ne "\[\e[36m\]${PWD/$HOME/~}"
        }
        prompt_mark() {
            echo -ne "\[\e[94m\]\$"
            echo -ne "\[\e[0m\]"
        }
    else
        prompt_whoami() {
            echo -ne "${USER}@${HOSTNAME}"
        }
        prompt_pwd() {
            echo -ne "${PWD/$HOME/~}"
        }
        prompt_mark() {
            echo -ne "\$"
        }
    fi
fi

prompt_cmdstatus() {
    local S fst=true EVAL="$1"
    if [[ "${EVAL}" -eq 0 ]] ; then
        #echo "    "
        echo "^_^ "
    else
        S="$EVAL*"

        while [[ "${#S}" -lt 4 ]]; do
            if $fst ; then
                S="${S}"
                fst=false
            else
                #S="*${S}"
                S=" ${S}"
            fi
        done
        echo "$S"
    fi
}

print_current_prompt() {
    local EVAL="$?" CSTATUS WHOAMI PDIR MARK

    history -a
    history -n

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