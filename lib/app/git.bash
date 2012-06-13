#! /bin/bash
# -*- mode: sh -*-

####################
### GIT Helpers  ###
####################

dir_is_git_managed() {
    [[ -d "$1" ]] || die "Cannot test for GIT tree - not a directory: $1"
    cd "$1" || die "Cannot test for GIT tree - 'cd' failed!"
    git rev-parse --verify --quiet HEAD > /dev/null
}

is_git_managed() {
    dir_is_git_managed "$PWD"
}

parse_git_dirty() {
    [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit (working directory clean)" ]] && echo "*"
}

parse_git_branch() {
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/[\1$(parse_git_dirty)]/"
}
