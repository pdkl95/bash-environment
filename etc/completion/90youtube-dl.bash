#!/bin/bash

__youtube-dl()
{
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    opts="\
-h --help \
--version \
-U --update \
-i --ignore-errors \
-r --rate-limit \
-R --retries \
--dump-user-agent \
--list-extractors \
--playlist-start --playlist-end \
--match-title --reject-title \
--max-downloads \
-t --title \
-l --literal \
-A --auto-number \
-o --output \
-a --batch-file \
-w --no-overwrites \
-c --continue \
--no-continue \
--cookies \
--no-part \
--no-mtime \
--write-description \
--write-info-json \
-q --quiet \
-s --simulate \
--skip-download \
-g --get-url \
-e --get-title \
--get-thumbnail \
--get-description \
--get-filename \
--get-format \
--no-progress \
--console-title \
-v --verbose \
-f --format \
--all-formats \
--prefer-free-formats \
--max-quality \
-F --list-formats \
--write-srt \
--srt-lang \
-u --username \
-p --password \
-n --netrc \
--extract-audio \
--audio-format 
--audio-quality \
-k --keep-video"

    if [[ ${cur} == * ]] ; then
        COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
        return 0
    fi
}

__youtube-dl-simple()
{
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    opts="\
-h --help \
--version \
-U --update \
-i --ignore-errors \
-r --rate-limit \
-R --retries \
--list-extractors \
-t --title \
-l --literal \
-o --output \
-a --batch-file \
-c --continue \
--cookies \
--no-part \
--no-mtime \
--write-description \
--write-info-json \
-q --quiet \
-s --simulate \
--skip-download \
-g --get-url \
-e --get-title \
--get-thumbnail \
--get-description \
--get-filename \
--get-format \
--no-progress \
--console-title \
-v --verbose \
-f --format \
--prefer-free-formats \
-F --list-formats \
--write-srt \
--srt-lang"

    if [[ ${cur} == * ]] ; then
        COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
        return 0
    fi
}

complete -F __youtube-dl youtube-dl
complete -F __youtube-dl-simple yt

# Local Variables:
# mode: sh
# sh-basic-offset: 4
# sh-shell: bash
# coding: unix
# End:
