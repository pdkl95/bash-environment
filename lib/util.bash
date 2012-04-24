#!/bin/bash

urxvt-set_font() {
    local font="${1:-xft:Terminus:pixelsize=14}"
    printf '\e]710;%s\007' "${font}"
}


fullpath() {
    local i
    for i in "$@" ; do
        if [[ "${i}" =~ ^/ ]] ; then
            readlink -f "${i}"
        else
            readlink -f "${PWD}/${i}"
        fi
    done
}

args_or_stdin() {
    if (( $# > 0 )) ; then
        fullpath "$@"
    else
        echo "/proc/${$}/fd/0"
    fi
}

uncomment() {
    oldIFD=$IFS
    local infiles="$(args_or_stdin "$@")"

    IFS=$'\n' cat "${infiles}" | sed -e 's/\([^#]*\)#.*$/\1/; /^[[:space:]]*$/d; /^#/d;'
    IFD=$oldIFS
}

fake_referror() {
    if [[ $# -eq 1 ]] && [[ "$1" =~ ^http:// ]] ; then
        local url=$(echo "$1" | cut -d/ -f2-3 )
        echo "${url}/"
    else
        echo "http://google.com/"
    fi
}

_curl() {
    ${CURL:-curl} \
        -A "$("${bashEV[BIN]}/useragent_select.bash")" \
        --cookie-jar ~/.curl_cookie.$$                 \
        --referer "$(fake_referrer "$1")"              \
        -H 'Accept: */*'                               \
        "$@"
}


_wget() {
    ${WGET:-wget} \
        --header='Accept-Language: en-us,en;q=0.5' \
        --header='Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' \
        --header='Connection: keep-alive' \
        --user-agent "$("${bashEV[BIN]}/useragent_select.bash")" \
        --referer=$(fake_referer $1) \
        "$@"
}

dl() {
    if have ${CURL:-curl} ; then
        _curl "$@"
    elif have ${WGET:-wget} ; then
        _wget "$@"
    else
        echo "cannot dl files; missing 'curl' or 'wget'!" 1>&2 /de
    fi
}


oddeven_rows() {
    E="$(tput sgr0)"
    oB="$(tput setaf 253 ; tput setab 16)"
    eB="$(tput setaf 255 ; tput setab 233)"
    sed -re "\
1~2   s/^(.*)$/${oB}\\1${E}/g; \
1~2 ! s/^(.*)$/${eB}\\1${E}/g"
}


tree_most_recent() {
    SRC=( "$@" )
    [[ ${#SRC} -lt 1 ]] && SRC+=( '.' )
    find "$@" -type f -printf "%A@ %Am/%Ad %AH:%AM %p\n" | sort -n | cut -d' ' -f2-
}



fullenv() {
    for _a in {A..Z} {a..z} ; do
        _z=\${!${_a}*}
        for _i in `eval echo "${_z}"` ; do
            echo -e "$_i: ${!_i}"
        done
    done | /bin/cat -Tsv
}

ff() {
    find . -type f "$@"
}

# Repeat n times command.
# repeat() {
#     local i max
#     max=$1
#     shift
#     for ((i=1; i <= max ; i++)); do
#         eval "$@"
#     done
# }

my_ip_from_outsie_prespective() {
    curl ifconfig.me
}
#alias my_ip="my_ip_from_outside_prespective"

mplayer_ident() {
     mplayer2 -msglevel all=0 -identify -frames 0 "$@"  2> /dev/null
}

could_become_mkv() {
    find . -type f -not -name *.wmv -not -name *.mkv
}



# Local Variables:
# mode: sh
# sh-basic-offset: 4
# sh-shell: bash
# coding: unix
# End:
