#!/bin/bash
# -*- mode: sh -*-

################
###  PROMPT  ###
################

current_ruby_version() {
    local OPT="$1"
    local V=$(rbenv version-name)
    local T="$V"

    case ${V} in
        1.8.7-p???) T='1.8.7' ;;
        1.9.3-*)    T='1.9.3' ;;
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

if [[ "${TERM}" =~ 256color ]] ; then
    _prompt() {
        case $1 in
            whoami)
                echo -ne "\[\e[38;5;28m\]${USER}"
                echo -ne "\[\e[38;5;40m\]@"
                echo -ne "\[\e[38;5;28m\]${HOSTNAME}"
                ;;
            dir)
                echo -ne "\[\e[38;5;44m\]${PWD/$HOME/~}"
                ;;
            mark)
                echo -ne "\[\e[48;5;18;38;5;63m\]\$"
                echo -ne "\[\e[0m\]"
                ;;
        esac
    }
elif [[ "${TERM}" =~ color ]] ; then
    _prompt() {
        case $1 in
            whoami)
                echo -ne "\[\e[32m\]${USER}"
                echo -ne "\[\e[92m\]@"
                echo -ne "\[\e[32m\]${HOSTNAME}"
                ;;
            dir)
                echo -ne "\[\e[36m\]${PWD/$HOME/~}"
                ;;
            mark)
                echo -ne "\[\e[94m\]\$"
                echo -ne "\[\e[0m\]"
                ;;
        esac
    }
else
    _prompt() {
        case $1 in
            whoami)
                echo -ne "${USER}@${HOSTNAME}"
                ;;
            dir)
                echo -ne "${PWD/$HOME/~}"
                ;;
            mark)
                echo -ne "\$"
                ;;
        esac
    }
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

_print_current_prompt() {
    local RV="$LASTCMD_RETVAL"
    local CSTATUS="$(prompt_cmdstatus $RV)"

    if _gitsh_is_active ; then
        xtitle "<$(git-current-branch)> $CSTATUS ${PWD/$HOME/~}"
        # this has to be backticks, not $(), or bash munges up
        # the ANSI escape codes. probably a better way to do this...
        export PS1='`_git_headname`!`_git_workdir``_git_dirty`> '
    else
        xtitle "$CSTATUS ${PWD/$HOME/~}/"
        export PS1="$(_prompt whoami) $(_prompt dir) $(_prompt mark) "
    fi
}

_bashEV_add_prompt_command _print_current_prompt
export PS1="\u@\h \w \$ "
