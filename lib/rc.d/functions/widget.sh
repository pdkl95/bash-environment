#! /bin/bash
# -*- mode: sh -*-


###############################
###  general utils/helpers  ###
###############################

function countdown
{
    local OLD_IFS="${IFS}"
    IFS=":"
    local ARR=( $1 )
    local SECONDS=$((  (ARR[0] * 60 * 60) + (ARR[1] * 60) + ARR[2]  ))
    local START=$(date +%s)
    local END=$((START + SECONDS))
    local CUR=$START

    while [[ $CUR -lt $END ]] ; do
        CUR=$(date +%s)
        LEFT=$((END-CUR))

        printf "\r%02d:%02d:%02d" \
            $((LEFT/3600)) $(( (LEFT/60)%60)) $((LEFT%60))

        sleep 1
    done
    IFS="${OLD_IFS}"
    echo "        "
}