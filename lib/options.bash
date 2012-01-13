ulimit -S -c 0

#umask 0022
umask 0002

set +C # noclobber
set +f # noglob
set +n # noexec
#------------------ <<< Remember '+' means *OFF* with set!
set -H # histexpand
set -b # notify
set -h # hashall
set -m # monitor
set -B # braceexpand


shopt -u huponexit failglob mailwarn cdable_vars
shopt -s checkhash checkwinsize cmdhist dotglob extglob extquote \
histappend histreedit histverify no_empty_cmd_completion promptvars
