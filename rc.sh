# -*- mode: sh -*-

# Shell is non-interactive?
[[ $- != *i* ]] && return


######################
###  Interactive!  ###
######################

# sandbox all the various bash stuff
export PDKL_HOME="${HOME}"
export PDKL_BASHDIR="${PDKL_HOME}/.bash"


#############################################################
# The basic loader so we can load the rest from other files #
#############################################################

safe_load() {
    [ -f "$1" ] && source "$1"
}

load_sh() {
    safe_load "${PDKL_BASHDIR}/$1.sh"
}

defer_load_sh() {
    local file="$(readlink -f "${PDKL_BASHDIR}/$1.sh")"
    shift
    # REQUIRED: $file must redefine all elements of "$@"
    #           it will cause $file to randomly be reloaded
    for x in "$@" ; do
        eval "$x() { source '"$file"'; $x \"\$@\"; }"
    done
}

add_path_prefix() {
    [[ "$PATH" =~ "$1" ]] || PATH="$1:$PATH"
}

add_project_root() {
    add_path_prefix "$1/bin"
}

add_project_root "${PDKL_HOME}"


###################################
# all real work is done elsewhere #
###################################

# this should always load first, as it contains things
# that other files we will load need
load_sh "setup"

# these are probably next, because they define constants that
# end up in a few places
load_sh "options"
load_sh "ansicolor"

# the core of our bash environment
load_sh "env"
load_sh "functions"

[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"
# UI
load_sh "prompt"
load_sh "aliases"
#load_sh "completion"
##defer_load_sh "mplayer_helper" "m" "mm"

unset safe_load load_sh add_path_prefix add_project_root

## rvm is implicitly loades leswhere instea of the traditional line here

