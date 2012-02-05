#!/bin/bash
#
# ---> ".profile" < ---
#
# when emulate ~/.bash_profile, this file
# will be eval()'d into the live, running
# shell *after* everythign else has been
# loaded or otherwise setup.
#
# If you want, you can think of it as having
# *ALREADY* an equivalent of
#        

### should only bring in the gpg_agent/ssh_agent
### tool once, to avoid confustion and conflicts
### Hopefullly ,t thethe login shell as they sould be sufficient?
eval `keychain --eval -q -Q --agents gpg,ssh id_dsa`


# Local Variables:
# mode: sh
# sh-basic-offset: 4
# sh-shell: bash
# coding: unix
# End:
