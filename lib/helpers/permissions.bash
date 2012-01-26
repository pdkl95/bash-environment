#!/bin/bash


##########################
###  File Permissions  ###
##########################

set_permissions() {
    local perm="$1" ; shift
    for i in "$@" ; do
        chmod "$perm" "$i"
    done
}

set_perm_exec()     { set_permissions +x  "$1" ; }
set_perm_editable() { set_permissions +w  "$1" ; }
set_perm_newfile()  { set_permissions +rw "$1" ; }

umask2mode() {
    echo "0777-$1" | bc
}

modify_current_umask() {
    for i in "$@"; do
        umask -- "$i"
    done
}

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

create_standard_file() {
    local noisy=true

    while [[ "$1" =~ ^[-] ]] ; do
        case "$1" in
            -q|--quiet)
                noisy=false ; shift ;;
            *)
                erropt 'create_standard_file' "Unknown option: $1"
                return $?
        esac
    done

    local path="${1:?create_new_file: missing filename-full-path to create!}"
    local tmpl="${2}"
    local mode="${3}"

    [[ -z "${tmpl}" ]] && tmpl="/dev/null"
    [[ -z "${mode}" ]] && mode=$(standard_file_mode)

    [[ -e "${tmpl}" ]] || die "create_new_file: template is missing: ${tmpl}"

    $noisy && echo install "--mode=${mode}" "${tmpl}" "${path}"
    install "--mode=${mode}" "${tmpl}" "${path}"
}


# Local Variables:
# mode: sh
# sh-basic-offset: 4
# sh-shell: bash
# coding: unix
# End:
