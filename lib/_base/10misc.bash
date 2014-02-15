#!/bin/bash

: ${TERM:=xterm-256color}
: ${INPUTRC:=$HOME/.inputrc}

# ${bashEV[HOME]}/.bash/bin:
PATH="\
${HOME}/bin:\
${HOME}/bin/elf:\
${HOME}/.cw/bin:\
${HOME}/opt/bin:\
${PATH}"

export TERM INPUTRC PATH

_is_varname() {
    [[ "$1" =~ ^[_[:alpha:]][_[:alnum:]]*$ ]]
}

_get() {
    local name="$1"
    #echo "_get '${name}'" 1>&2
    if [[ -v "${name}" ]] ; then
        echo "${!name}"
    else
        return 1
    fi
}

_set() {
    local name="$1" val="$2"
    #echo "_set '${name}' '${val}'" 1>&2
    if _is_varname "${name}" ; then
        eval "${name}=\${val}"
    else
        echo "NOT A VALID VARIABLE NAME: '${name}'"
    fi
}



. /usr/local/share/chruby/chruby.sh
#chruby ruby-2.0.0-p353
chruby ruby-2.1.0

#${HOME}/.rbenv/shims:\

# declare rbenv_src="$(
# rbenv() {
#   local command
#   command="$1"
#   if [ "$#" -gt 0 ]; then
#     shift
#   fi

#   case "$command" in
#   rehash|shell)
#     eval "`rbenv "sh-$command" "$@"`";;
#   *)
#     command rbenv "$command" "$@";;
#   esac
# }
# declare -f rbenv
# )
# "
# case $(type -t rbenv) in
#     file)
#         eval "${rbenv_src}"
#         ;;
#     function)
#         if [[ "${rbenv_src}" == "$(declare -f rbenv)" ]] ; then
#             :  # no need to redefine the funciton
#         else
#             derror ".bashrc ERROR: rbenv() changed to an unknown function:" 1>&2
#             declare -f rbenv 1>&2
#         fi
#         ;;
#     *)
#         derror ".bashrc ERROR: cannot wrap rbenv which hass " 1>&2
#         derror "               already been defined as:" 1>&2
#         type rbenv 1>&2
#         ;;
# esac
# unset rbenv_src

# guess color mode from the terminal name
# if it's not set already
if [[ "$TERM" =~ xterm ]] ; then
    TERM="xterm-256color"
fi

# Allow color-wrapper to work in non-pipe situations
NOCOLOR_PIPE=1

# 256 color support for grep!
GREP_COLORS="rv:mt=38;5;197;1:sl=48;5;234:cx=38;5;247:fn=48:5:240:38;5;46:ln=38;5;208:bn=38;5;227:se=48;5;17;38;5;33"

# etc
TIMEFORMAT=$'\nreal %3R\tuser %3U\tsys %3S\tpcpu %P\n'
FIGNORE='.o:~'

VBOX_APP_HOME="/opt/VirtualBox"

_add_to_path_var() {
    local varname="$1" ; shift
    local oldIFS="${IFS}"
    local do_add value

    for x in "$@" ; do
        do_add=true
        value="${!varname}"
        IFS=":"
        for i in ${value} ; do
            if [[ "${i}" == "${x}" ]] ; then
                do_add=false
            fi
        done
        IFS="${oldIFS}"

        if ${do_add} ; then
            if [[ -n "${cur}" ]] ; then
                value="${x}"
            else
                value="${x}:${value}"
            fi
            eval "${varname}='${value}'"
        fi
    done
}

# set the default value if necessary

: ${PKG_CONFIG_PATH:=/usr/lib64/pkgconfig:/usr/share/pkgconfig}
_add_to_path_var PKG_CONFIG_PATH "/usr/local/lib/pkgconfig"
export PKG_CONFIG_PATH

#export NOCOLOR_PIPE GREP_COLORS TIMEFORMAT FIGNORE

# *** HACK ***
# Workaround for how Gentoo deals with ruygems. We manage it
# entirely separate from the distory anyway (rbenv/bundler), so this
# has little utility anyway.
#export RUBYOPT=""

#export RBENV_SHELL=bash

# ruby gc tuning
# export RUBY_HEAP_MIN_SLOTS=1000000
# export RUBY_HEAP_SLOTS_INCREMENT=1000000
# export RUBY_HEAP_SLOTS_GROWTH_FACTOR=1
# export RUBY_GC_MALLOC_LIMIT=1000000000
# export RUBY_HEAP_FREE_MIN=500000


# Local Variables:
# mode: sh
# sh-basic-offset: 4
# sh-shell: bash
# coding: unix
# End:
