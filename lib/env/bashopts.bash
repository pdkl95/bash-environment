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
shopt -s checkhash checkwinsize cmdhist
shopt -s dotglob extglob extquote
shopt -s histappend histreedit histverify
shopt -s no_empty_cmd_completion promptvars
