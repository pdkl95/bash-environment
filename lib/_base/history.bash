#! /bin/bash
# -*- mode: sh -*-

#################
###  History  ###
#################

# where save it
#export HISTFILE="${bashEV[ROOT]}/var/history.list"
export HISTFILE="${HOME}/var/history/bash"

# HUGE history file! why not, we have the disk...
export HISTSIZE=1000000
export HISTFILESIZE=$HISTSIZE

# # ALLOWING dupes, again because disk is basically free
# # it wil allow for some interesting statistics to be generated
# # aft some time, as a bonus...
# export HISTCONTROL="ignorespace"

# nevermind, cutting dups for now

export HISTCONTROL="ignorespace:ignoredups"

# these are SO generic, though, that we suould it's stil
# worth filtering them (notable exceptio: cd and ls are
# logged!) or just useless
export HISTIGNORE="bg:fg::m:mm:mplayer:mplayer2:top:clear:exit"

# make the output look nicer than timestaps (see: "man strftime")
#export HISTIMEFORMAT='%Y-%b-%d %k:%M'
#export HISTTIMEFORMAT='%b-%d %k:%M | '
export HISTTIMEFORMAT='%Y%m%d-%R | '
#(the year seems overkill)

export HISTLASTCMD=""


LOCAL_HISTDIR="${HISTFILE}.d"
LOCAL_LOADTIME="$(date "+%Y%m%d-%H%M.%3N")"

_prompt_command__history_lastcmd() {
    # save the last command to the history log
    history -a

    # read it back...
    local cmd="$(history 1)"
    if [[ "${cmd}" != "${HISTLASTCMD}" ]] ; then
        # only proceed if this is NOT a dupe entry!
        # Such entries are possible as $(history 1) might
        # not know about the actual previous command if
        # it was, for example, preceded by a " " to keep
        # it from being logged by history at all
        local raw="${cmd#*| }"
        local bin="${raw%% *}"

        # log the command with extra data, if possible
        local extra_log="${HISTFILE}.extra"
        local local_log="${LOCAL_HISTDIR}/${LOCAL_LOADTIME}"

        mkdir -p "${LOCAL_HISTDIR}"

        local ex="PWD=${PWD}"

        case $bin in
            cd|CD) ex="'${ex}' OLDPWD='${OLDPWD}'" ;;
        esac

        for var in SSH_CONNECTION ; do
            if [[ -v $var ]] ; then
                ex="${ex} ${var}=${!var}"
            fi
        done

        local log_entry="${cmd}  ### ${ex}"
        echo "${log_entry}" >> "${extra_log}"
        echo "${log_entry}" >> "${local_log}"

        # finally, save the command for comparison
        HISTLASTCMD="${cmd}"
    fi
}

#_add_prompt_command history_lastcmd
