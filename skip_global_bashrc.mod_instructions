# -*- mode: sh -*-
#
#######################################
# Modification to the global bash init, so we can take over
# the process completely as a user. As there's no way to
# disable running of the global bashrc, a flag is necessary
# so we can simply return, skipping any distro-provided
# init that we are probably rewriting anyway.
#
#  *** COPY THIS PREFIX INTO THE TOP OF:
#         /etc/bashrc
#         /etc/bash/bashrc
#
# (exact location varies by distro)


#### <BEGIN COPY> ####

# disabled by user?
if [ -e "$HOME/.bash/skip_global_bashrc" ] ; then
        return
fi


#### <END COPY> ####


# It should be put at the very top of the file; probably
# just before something that looks like this:
#
#   if [[ $- != *i* ]] ; then
#       # Shell is non-interactive.  Be done now!
#       return
#   fi
