#!/bin/bash

# kill XON/XOFF (^s/^q) flow control
stty -ixon

bashEV_include "ui/ansicolor"
bashEV_include "ui/messages"
bashEV_include "ui/widgets"
bashEV_include "ui/prompt"

# Local Variables:
# mode: sh
# sh-basic-offset: 4
# sh-shell: bash
# coding: unix
# End:
