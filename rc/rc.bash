#!/bin/bash

source "${bashEV_BOOTSTRAP:-${HOME}/.bash/BOOTSTRAP.bash}"

[[ $- != *i* ]] && return  # Shell is non-interactive?

bashEV_load_standard_libs
