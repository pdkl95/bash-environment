#!/bin/bash

ls_format() {
    # value for "-n 1024" found by experimatation ; may need
    # to change for optimal speed...
    xargs -n 1024 ls -1 -U -L --directory --color "$@"
}

ls_format_long() {
    ls_format -l --human-readable
}


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

du_sort() {
    local SRC=( "$@" )
    [[ ${#SRC} -lt 1 ]] && SRC+=( * )
    command du --block-size=1k --human-readable --summarize "${SRC[@]}" | sort -h
}
alias dus="du_sort"


_lstree_find() {
    local pr="$1" ; shift
    find -L "${@}" -type f -printf "${pr}%p\n"
}
_lstree_sort() {
    local sort="$1" ; shift
    _lstree_find "${sort} " "${@}" | sort -n | cut -d' ' -f2-
}

lstree() {
    local sort="%p" long=false
    while (( $# > 0 )) ; do
        case $1 in
            -l) long=true  ; shift 1 ;;
            -S) sort="%s"  ; shift 1 ;;
            -c) sort="%C@" ; shift 1 ;;
            -t) sort="%T@" ; shift 1 ;;
            -u) sort="%A@" ; shift 1 ;;
            --) shift ; break ;;
            -*) echo "unknown option: $1" 1>&2 ; return 1 ;;
            *)  break ;;
        esac
    done

    local SRC=( "$@" )
    [[ ${#SRC} -lt 1 ]] && SRC+=( '.' )

    if $long ; then
        _lstree_sort "${sort}" "${SRC[@]}" | ls_format_long
    else
        _lstree_sort "${sort}" "${SRC[@]}" | ls_format
    fi
}
alias lstree_size="lstree -S"
alias lstree_atime="lstree -u"
alias lstree_ctime="lstree -c"
alias lstree_mtime="lstree -t"
alias lst="lstree"
alias lsts="lstree -S -l"
alias lstt="lstree -t -l"

cfind()     { find "$@" -printf "%p\n" | ls_format      ; }
cfindlong() { find "$@" -printf "%p\n" | ls_format_long ; }



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
