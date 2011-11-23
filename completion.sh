# do nothing if completion is off globally
if [ -x "$(complete -p)" ]; then
    return
fi

[ -n "${rvm_path}" ] && safe_load "${rvm_path}/scripts/completion"


# not ready yet
#safe_load "${PDKL_BASHDIR}/completion.d/ruby-gems.sh"
