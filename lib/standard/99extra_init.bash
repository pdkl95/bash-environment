#!/bin/bash

if [[ -v bashEV_AUTOLOAD_ENV ]] ; then
    declare env_name
    for env_name in $(pathlike_split "${bashEV_AUTOLOAD_ENV}") ; do
        pushenv "${env_name}"
    done
    unset env_name

    if [[ -v bashEV_AUTOLOAD_ENV_EXPORT ]] ; then
        export bashEV_AUTOLOAD_ENV bashEV_AUTOLOAD_ENV_EXPORT
    else
        unset bashEV_AUTOLOAD_ENV
    fi
fi

if [[ -v bashEV_AUTOSOURCE_FILES ]] ; then
    declare file_path
    for file_path in $(pathlike_split "${bashEV_AUTOSOURCE_FILES}") ; do
        source "${file_path}"
    done
    unset file_path

    if [[ -v bashEV_AUTOSOURCE_FILES_EXPORT ]] ; then
        export bashEV_AUTOSOURCE_FILES bashEV_AUTOSOURCE_FILES_EXPORT
    else
        unset bashEV_AUTOSOURCE_FILES
    fi
fi

# Local Variables:
# mode: sh
# sh-basic-offset: 4
# sh-shell: bash
# coding: unix
# End:
