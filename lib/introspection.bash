function __DIR__ {
    local SRC="${BASH_SOURCE[0]}"
    while [ -h "$SRC" ] ; do
        SRC="$(readlink "$SRC")"
    done
    cd -P "$(dirname "$SRC")" && pwd
}

function __FILE__ {
    echo "$(__DIR__)/${BASH_SOURCE[0]}"
}
