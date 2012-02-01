# init the bash environment like normal
[ -f ~/.bashrc ] && source ~/.bashrc

# then, lauch the things that live for the whole login session
eval `keychain --eval -q -Q --agents gpg,ssh id_dsa`
