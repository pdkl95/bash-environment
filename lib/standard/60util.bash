#!/bin/bash

man() {
    local i
    for i ; do
        xtitle man -a $(basename $1|tr -d .[:digit:])
        command man -a "$i"
    done
}

pdf() {
    local i
    for i in "$@" ; do
        zathura "$i" &disown
    done
}

cs() {
    cd "$1"
    l
}

# all man pages!
current_ruby_Version() {
    rbenv version | cut -d\  -f 1
}

current_rbenv_base() {
    echo "~/.rbenv/versions/${current_ruby_version}/"
}

current_gemdir() {
    echo "$(gem env gemdir)"
}

alias cdgemdir="cd \$(current_gemdir)/gems"

vid_enc_commit() {
    reenc="${1}"
    orig="${reenc%.NEW_ENCODING.*}"
    base="${orig%.*}"
    new="${base}.mkv"
    if [[ -e "${new}" ]] ; then
        derror "would clobber: ${new}" ; return 1
    elif ! [[ -e "${reenc}" ]] ; then
        derror "missing reencoded version: ${reenc}" ; return 1
    elif ! [[ -e "${orig}" ]] ; then
        derror "(???) original version is missing: ${orig} (???)" ; return 1
    else
        dshowexec rm -v "${orig}"
        dshowexec mv -i "${reenc}" "${new}"
    fi
}
alias vok="vid_enc_commit"

mkdir_cd() {
    if [[ -e "$1" ]] ; then
        if [[ -d "$1" ]] ; then
            dinfo 'mkdir_cd' "dir already exists: $1"
        else
            derror 'mkdir_cd' "blocked by: $1" ; return $?
        fi
    else
        dshowexec mkdir -p "$1"
    fi
    cd "$1"
}
alias CD="mkdir_cd"

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
    if is_cmd ${CURL:-curl} ; then
        _curl "$@"
    elif is_cmd ${WGET:-wget} ; then
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


escape_newlines() {
    sed -e :a -e N -e 's/\n/\\n/' -e ta
}

lsenv() {
    local _a _z _i
    for _a in {A..Z} {a..z} ; do
        _z=\${!${_a}*}
        for _i in `eval echo "${_z}"` ; do
            echo -ne "$_i="
            printf '%q' "${!_i}"
            echo
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

java_env() {
    local -x JAVA_HOME="$(/usr/bin/java-config -g JAVA_HOME)"
    local -x JDK_HOME="$(/usr/bin/java-config -g JDK_HOME)"
    local -x JAVAC="$(/usr/bin/java-config -g JAVAC)"
    local -x PATH="$(/usr/bin/java-config -g PATH):${PATH}"

    local -x LDPATH="$(/usr/bin/java-config -g LDPATH)"
    if [[ -n "${LD_LIBRARY_PATH}" ]] ; then
        local -x LD_LIBRARY_PATH="${LDPATH}:${LD_LIBRARY_PATH}"
    else
        local -x LD_LIBRARY_PATH="${LDPATH}"
    fi

    declare -p PATH LD_LIBRARY_PATH
    echo
    echo
    dshowexec "$@"
}

# Local Variables:
# mode: sh
# sh-basic-offset: 4
# sh-shell: bash
# coding: unix
# End:
