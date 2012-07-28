#! /bin/bash
# -*- mode: sh -*-

##########################################
# select an editor fin order of preference

first_available() {
    for e in $@ ; do
        if is_cmd $e ; then
            echo $e
            return
        fi
    done
    derror "WARNING: no suitable choice for $EDITOR could be found!"
    derror "!!!!!!!! Falling ack the exing EDITOR=$EDITOR"
}
export EDITOR="$(first_available zile nano vim vi)"
export VISUAL="$(first_available me zile nano gvim vim vi)"


##############################################################
### File Permission Fixing

umask2mode() {
    echo "0777-$1" | bc
}

modify_current_umask() {
    for i in "$@"; do
        umask -- "$i"
    done
}

############################################################
###  New File Creation
current_umask() {
    # must do this in a subshell, or we overwite
    # current umask in THIS shell
    echo $(modify_current_umask "$@"; umask)
}

current_umask_mode() {
    local mask=$(current_umask "$@")
    umask2mode $mask
}

standard_file_mode() {
    current_umask_mode -x
}

#########################################################
###  Templating of common file fomats on creatio

export NEWFILE_TEMPLATE_DIR="${bashEV[ETC]}/templates"

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


create_from_template() {
    local path="$1"
    local tmpl="$(template_for "$path")"
    if [[ -n "${tmpl}" ]] ; then
        dshowexec install "--mode=$(standard_file_mode)" "${tmpl}" "${path}"
    else
        dwarn "no template for \"$(basename $path)\""
    fi
}

can_edit() {
    [[ -r "$1" ]] && [[ -w "$1" ]]
}

prepare_for_editing() {
    for file in "$@" ; do
        case $file in
            -*) : ;; # skip options
            *)  if ! [[ -e "$file" ]] ; then
                    create_from_template "$file"
                fi ;;
        esac
    done
}


##########################################
###  Finally, Editor-Specific Details  ###
##########################################

bashEV_include "editor/emacs"

_me() {
    prepare_for_editing "$@"
    command me "$@" &disown
}
alias me="_me"
