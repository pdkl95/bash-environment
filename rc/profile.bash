# if [ -z "${PDKL_ENV}" ] ; then
#   export PDKL_ENV="profile"
# else
#   export PDKL_ENV="${PDKL_ENV} %%RESTART%% profile"
# fi

# trap 'echo -e "\n\n\n!!! TERMINATED SIG: [$?] AT LINE:$LINENO AFTER $SECONDS SECONDS !!!\n"|tee -a $SSH_TTY;' KILL TERM HUP EXIT

[ -f ~/.bashrc ] && source ~/.bashrc

#eval `keychain --eval -q -Q --agents gpg,ssh id_dsa`
