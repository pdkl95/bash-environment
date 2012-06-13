#!/bin/bash

dbegin "[bashEV: ${bashEV_ENV_NAME}]: Loading"

FILES="$(cd "${bashEV_ENV_DIR}" && ls [^_.]*.bash)"

for file in "${FILES}" ; do
    source "${bashEV_ENV_DIR}/${file}"
done

dend "[bashEV: ${bashEV_ENV_NAME}]: ERROR!"

# Local Variables:
# mode: sh
# sh-basic-offset: 4
# sh-shell: bash
# coding: unix
# End:
