
BASHLIB="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
#BASHLIB="$( dirname "${BASH_SOURCE[0]}"}"
BASHENV="$(dirname "$BASHLIB" )"

declare -A rcpath
rcpath[inputrc_standard]="$HOME/.inputrc"
rcpath[bashrc_standard]="$HOME/.bashrc"
rcpath[profile_standard]="$HOME/.bash_profile"
rcpath[inputrc_local]="${BASHLIB}/inputrc"
rcpath[bashrc_local]="${BASHLIB}/bashrc.bash"
rcpath[profile_local]="${BASHLIB}/profile.bash"

echo_info() {
    local from="${FUNCNAME[1]}"
    echo "<${from}> $@"
}

echo_error() {
    local from="${FUNCNAME[1]}"
    echo "<${from}> $@" 1>&2
}

echo_and_run() {
    local from="${FUNCNAME[1]}"
    echo "<${from}> EXEC: $@"
    "$@"
}

die() {
    echo_error "FATAL ERROR!!"
    for line in "$@"; do
        echo_error "$line"
    done
    exit -1
}

is_defined() {
    declare -p $1 >/dev/null 2>&1
}

is_cmd() {
    command command type $1 &>/dev/null || return 1
}

in_X() {
    [[ -n "$XAUTHORITY" ]]
}

can_run() {
    [[ -x "$(command which $1)" ]]
}

can_run_as_sudo() {
    can_run sudo && sudo -l "$@" 2>/dev/null
}

can_run_as_su() {
    can_run su
}
