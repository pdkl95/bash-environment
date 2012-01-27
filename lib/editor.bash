#! /bin/bash
# -*- mode: sh -*-

##########################################
# select an editor fin order of preference

select_prefered_editor() {
    for e in "zile" "emacs" "nano" "vim" "vi" ; do
        if is_cmd $e ; then
            export EDITOR="$e"
            return
        fi
    done
    # bad, none were found!
    echoerr "WARNING: no suitable choice for $EDITOR could be found!"
    echoerr "!!!!!!!! Falling ack the exing EDITOR=$EDITOR"
}
select_prefered_editor
export VISUAL="${EDITOR}"

export NEWFILE_TEMPLATE_DIR="${bashETC}/templates"

template_for_tname() {
    local T="${NEWFILE_TEMPLATE_DIR}/$1"
    [[ -r "$T" ]] && echo "$T"
}

template_for_name() { template_for_tname "name/$1" ; }
template_for_ext()  { template_for_tname "ext/$1"  ; }

template_for() {
    local name="$(basename "$1")"
    local ext="${name##*.}"
    template_for_name "$name" || template_for_ext "$ext"
}

# create an empty file, possibly from a template
create_empty_file() {
    if [[ -e "$1" ]] ; then
        echo "exists: $1"
        return 1
    else
        local T
        if T="$(template_for "$1")" ; then
            echo "NEWFILE: creating from template \"$T\""
            create_standard_file --quiet "$1" "$T"
            [[ -x "$T" ]] && set_perm_exec "$1"
        else
            echo "NEWFILE: creating empty file"
            create_standard_file --quiet "$1"
        fi
        return 0
    fi
}

can_edit() {
    [[ -r "$1" ]] && [[ -w "$1" ]]
}

# prepare a file for editing, creating a new file if necessary
prepare_file_for_editing() {
    local file="$1"
    if [[ -e "$file" ]] ; then
        can_edit "$file" || set_perm_editable "$file"
    else
        create_empty_file "$file"
    fi
}

prepare_for_editing() {
    while [[ $1 = -* ]] ; do
        case "$1" in
            *)
                : # skip options
                shift ;;
        esac
    done
    for file in "$@" ; do
        prepare_file_for_editing "$file"
    done
}

is_cmd emacs && load_bash_lib "editor/emacs"
is_cmd me    && load_bash_lib "editor/jasspa_microemacs"
