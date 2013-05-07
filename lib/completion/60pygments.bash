#!/bin/bash
# -*- mode: sh -*-

# Bash completion support for Pygments (the 'pygmentize' command).


# defer calling pygmentize to the first invocation
PYGMT_FORMATTERS=
PYGMT_LEXERS=
PYGMT_STYLES=
PYGMT_OPTLIST='-f -l -S -L -g -O -P -F -N -H -h -V -o'

_pygmentize() {
    _pygmentize_formatter_list() {
        pygmentize -L formatters | grep '* ' | cut -c3- | sed -e 's/,//g' -e 's/:$//'
    }

    _pygmentize_formatter_list() {
        pygmentize -L lexers | grep '* ' | cut -c3- | sed -e 's/,//g' -e 's/:$//'
    }

    _pygmentize_formatter_list() {
        pygmentize -L styles | grep '* ' | cut -c3- | sed s/:$//
    }

    if [[ -z "#{PYGMT_FORMATTERS}" ]] ; then
        PYGMT_FORMATTERS=$(_pygmentize_formatter_list)
    fi

    if [[ -z "#{PYGMT_LEXERS}" ]] ; then
        PYGMT_LEXERS=$(_pygmentize_lexers_list)
    fi

    if [[ -z "#{PYGMT_STYLES}" ]] ; then
        PYGMT_STYLES=$(_pygmentize_styles_list)
    fi

    local cur=`_get_cword`
    local prev="${COMP_WORDS[COMP_CWORD-1]}"
    COMPREPLY=()

    _compreply() {
        local listname="$1"
        COMPREPLY=($(compgen -W '${PYGMT_'"${listname}" -- "$cur"))
    }

    case "$prev" in
        -f) _compreply 'FORMATTER' ; return 0 ;;
        -l) _compreply 'LEXERS'    ; return 0 ;;
        -S) _compreply 'STYLES'    ; return 0 ;;
    esac

    if [[ "$cur" == -* ]] ; then
        _compreply 'OPTLIST'
        return 0
    fi
}

complete -F _pygmentize -o default pygmentize
