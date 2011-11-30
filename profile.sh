# if [ -z "${PDKL_ENV}" ] ; then
#   export PDKL_ENV="profile"
# else
#   export PDKL_ENV="${PDKL_ENV} %%RESTART%% profile"
# fi

[ -f ~/.bashrc ] && source ~/.bashrc

#eval `keychain --eval -q -Q --agents gpg,ssh id_dsa`
