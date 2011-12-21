ulimit -S -c 0

#umask 0022
umask 0002

#set +v # verbose
#set +x # xtrace
set +C # noclobber
set +f # noglob
set +n # noexec
#------------------ <<< Remember '+' means *OFF* with set!
set -H # histexpand
set -b # notify
set -h # hashall
set -m # monitor
set -B # braceexpand

shopt -s checkwinsize checkhash
shopt -s autocd promptvars
shopt -s extquote extglob globstar dotglob
shopt -s histappend histreedit histverify cmdhist
shopt -s no_empty_cmd_completion
shopt -u checkjobs huponexit
shopt -u failglob mailwarn cdable_vars
