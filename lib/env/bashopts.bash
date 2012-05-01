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

set -o emacs

#shopt -u huponexit
shopt -u failglob force_fignore
shopt -u nocaseglob nocasematch
shopt -u mailwarn sourcepath cdable_vars
shopt -u dotglob

shopt -s checkhash checkwinsize cmdhist
shopt -s extquote hostcomplete
shopt -s extglob globstar
shopt -s histappend histreedit histverify
shopt -s no_empty_cmd_completion progcomp
shopt -s promptvars autocd
