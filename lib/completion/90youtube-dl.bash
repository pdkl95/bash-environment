##########################################################################
#
# SHORT OPTS:
#     echo $(youtube-dl --help | egrep '[-][-]' | cut -c5- \
#         | grep '^[-].[,] ' | cut -d, -f1 | LC_ALL=C sort)
# 
# LONG OPTS:
#     echo $(outube-dl --help | egrep '[-][-]' | cut -c5- \
#         | sed -re 's/^[-].[,][ ]([-][-][^ ]+)/\1/; s/^([-][-][^ ]+).*$/\1/' \
#         | LC_ALL=C sort
#

__youtube-dl()
{
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"

    shotopts="-A -F -R -U -a -c -e -f -g -h -i -j -k -l -n -o -p -q -r -s -t -u -v -w -x"
    longopts="--abort-on-error --add-metadata --age-limit --all-formats --all-subs --audio-format --audio-quality --auto-number --autonumber-size --batch-file --bidi-workaround --buffer-size --cache-dir --console-title --continue --cookies --date --dateafter --datebefore --default-search --download-archive --dump-intermediate-pages --dump-json --dump-user-agent --embed-subs --extract-audio --extractor-descriptions --format --get-description --get-duration --get-filename --get-format --get-id --get-thumbnail --get-title --get-url --help --id --ignore-config --ignore-errors --include-ads --keep-video --list-extractors --list-formats --list-subs --literal --load-info --match-title --max-downloads --max-filesize --max-quality --max-views --min-filesize --min-views --netrc --newline --no-cache-dir --no-check-certificate --no-continue --no-mtime --no-overwrites --no-part --no-playlist --no-post-overwrites --no-progress --no-resize-buffer --output --password --playlist-end --playlist-start --prefer-avconv --prefer-ffmpeg --prefer-free-formats --print-traffic --proxy --quiet --rate-limit --recode-video --referer --reject-title --restrict-filenames --retries --simulate --skip-download --socket-timeout --sub-format --sub-lang --title --update --user-agent --username --verbose --version --video-password --write-annotations --write-auto-sub --write-description --write-info-json --write-pages --write-sub --write-thumbnail --xattrs --youtube-include-dash-manifes"



    opts="${shortopt} ${longopts}"

    if [[ ${cur} == * ]] ; then
        COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
        return 0
    fi
}

complete -F __youtube-dl youtube-dl

