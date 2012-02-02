# helpers for running the mkv tools

mkvid() {
    local file="$1"
    mkvmerge --identify "$file"
}
