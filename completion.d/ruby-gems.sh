if type -p gem 2>/dev/null ; then
    # based heavily on "git-completion.bash"
    function __gemcomp {
        local all c s=$'\n' IFS=' '$'\t'$'\n'
        local cur="${COMP_WORDS[COMP_CWORD]}"
        if [ $# -gt 2 ]; then
            cur="$3"
        fi
        for c in $1; do
            case "$c$4" in
                --*=*) all="$all$c$4$s" ;;
                *.)    all="$all$c$4$s" ;;
                *)     all="$all$c$4 $s" ;;
            esac
        done
        IFS=$s
        COMPREPLY=($(compgen -P "$2" -W "$all" -- "$cur"))
        return
    }

    function __gem_complete_file {
        COMPREPLY=()
    }

    function __gem_complete_file_gemspec {
        __gem_complete_file
    }

    function __gem_complete_gemname {
        __gemcomp "$(gem list --no-details --no-versions)"
    }

    function __gem_complete_gemnameversion {
        __gem_complete_gemname
    }

    function __gem_commands {
        if [ -n "${__gem_commandlist}" ]; then
            echo "${__gem_commandlist}"
            return
        fi
        gem help commands | sed -e '/^  /! d; s/^ *//; s/ .*$//'
    }
    __gem_commandlist=
    __gem_commandlist="$(__gem_commands 2>/dev/null)"

    function __gem_stdopt_short {
        echo "-h -V -q"
    }

    function __gem_stdopt_long {
        echo "--help --verbose --no-verbose --quiet --config-file= --backtrace --debug"
    }

    function __gem_options {
        local cur="${COMP_WORDS[COMP_CWORD]}" short="$1" long="$2"
        shift 2
        case "$cur" in
            --*)
                __gemcomp "$(__gem_stdopt_long) ${long}"
                return
                ;;
            -*)
                __gemcomp "$(__gem_stdopt_short) ${short}"
                return
                ;;
        esac
        COMPREPLY=()
    }

    function __gem_localremote_options {
        local short="$1" long="$2"
        __gem_options "-l -r -b -B -p ${short}" "\
            --local
            --remote
            --both
            --bulk-threshold=
            --clear-sources
            --source=
            ${long}"
    }

    function __gem_gemnames_or_options {
        case "${COMP_WORDS[COMP_CWORD]}" in
            -*) __gem_options "$1" "$2" ;;
            *)  __gem_complete_gemname ;;
        esac
    }

    function __gem_gemnames_or_localremote_options {
        case "${COMP_WORDS[COMP_CWORD]}" in
            -*) __gem_localremote_options "$1" "$2" ;;
            *)  __gem_complete_gemname ;;
        esac
    }


    function _gem_build {
        case "${COMP_WORDS[COMP_CWORD]}" in
            -*) __gem_options ;;
            *)  __gem_complete_file_gemspec ;;
        esac
    }

    function _gem_cert {
        __gem_options '-a -l -r -b -C -K -s' '\
            --add=
            --list
            --remove=
            --build=
            --certificate=
            --private-key=
            --sign='
    }

    function _gem_check {
        __gem_options '-a -v' '\
            --verify=
            --alien
            --version='
    }

    function _gem_cleanup {
        __gem_gemnames_or_options '-d' '--dryrun'
    }

    function _gem_contents {
        __gem_gemnames_or_options '-v -s -l' '\
            --version=
            --all
            --spec-dir=
            --lib-only --no-lib-only
            --prefix --no-prefix'
    }

    function _gem_dependency {
        __gem_gemnames_or_localremote_options '-v -R' '\
            --version=
            --platform=
            --prerelease --no-prerelease
            --reverse-dependencies --no-reverse-dependencies
            --pipe'
    }

    function _gem_environment {
        case "${COMP_WORDS[COMP_CWORD]}" in
            -*) __gem_options ;;
            *)  __gemcomp "packageversion gemdir gempath version remotsources platform" ;;
        esac
    }

    function _gem_fetch {
        __gem_gemnames_or_options '-v -B -p', '\
            --version=
            --platform=
            --prerelease --no-prerelease
            --bulk-threshold=
            --http-proxy --no-http-proxy
            --source='
    }

    function _gem_generate_index {
        __gem_options '-d' '\
            --directory=
            --legacy --no-legacy
            --modern --no-modern
            --update
            --rss-gems-host=
            --rss-host=
            --rss-title='
    }

    function _gem_help {
        case "${COMP_WORDS[COMP_CWORD]}" in
            -*) __gem_options ;;
            *)  __gemcomp "commands examples ${__gem_commandlist}"
        esac
    }

    function _gem_install {
        __gem_options '' ''
    }

    function _gem_list {
        __gem_options "-i -v -d -a" "\
            --installed --no-installed
            --version
            --details --no-details
            --versions --no-versions
            --all"
    }

    function _gem_lock {
        case "${COMP_WORDS[COMP_CWORD]}" in
            -*) __gem_options '-s' '--strict --no-strict' ;;
            *)  __gem_complete_gemnameversion ;;
        esac
    }

    function _gem_outdated {
        __gem_localremote_options '' '--platform='
    }

    function _gem_owner {
        __gem_options '-k -a -r -p' '\
            --key=
            --add=
            --remote=
            --http-proxy --no-http-proxy'
    }

    function _gem_pristine {
        __gem_options '' ''
    }

    function _gem_push {
        __gem_options '' ''
    }

    function _gem_query {
        __gem_localremote_options '-i -v -n -d -a' '\
          --installed --no-installed
          --version=
          --name-matches=
          --details --no-details
          --versions --no-versions
          --all
          --prerelease --no-prerelease'
    }

    function _gem_rdoc {
        __gem_options '' ''
    }

    function _gem_search {
        __gem_options '' ''
    }

    function _gem_server {
        __gem_options '-p -d -b -l' '\
            --port=
            --dir=
            --daemon --no-daemon
            --bind=
            --launch'
    }

    function _gem_sources {
        __gem_options '-a -l -r -c -u -p' '\
            --add=
            --list
            --remove=
            --clear-all
            --update
            --http-proxy --no-http-proxy'
    }

    function _gem_speciication {
        __gem_options '' ''
    }

    function _gem_stale {
        __gem_options
    }

    function _gem_uninstall {
        __gem_options '' ''
    }

    function _gem_unpack {
        __gem_gemnames_or_options '-v' '--target= --spec --version='
    }

    function _gem_update {
        __gem_options '' ''
    }

    function _gem_which {
        __gem_options '' ''
    }

    function __gem {
        case "${COMP_WORDS[COMP_CWORD]}" in
            --*=*) COMPREPLY=() ;;
            --*)   __gemcomp "--help --version" ;;
            -*)    __gemcomp "-h -v" ;;
            *)     __gemcomp "$(__gem_commands)" ;;
        esac
    }

    function _gem {
        local command
        [ $COMP_CWORD -gt 1 ] && command="${COMP_WORDS[1]}"
        [ $COMP_CWORD -eq 1 ] && [ -z "$command" ] && __gem && return

        case "$command" in
            build)          _gem_build ;;
            cert)           _gem_cert ;;
            check)          _gem_check ;;
            cleanup)        _gem_cleanup ;;
            contents)       _gem_contents ;;
            environment)    _gem_environment ;;
            fetch)          _gem_fetch ;;
            generate_index) _gem_generate_index ;;
            help)           _gem_help ;;
            install)        _gem_install ;;
            list)           _gem_list ;;
            lock)           _gem_lock ;;
            outdated)       _gem_outdated ;;
            owner)          _gem_owner ;;
            pristine)       _gem_pristine ;;
            push)           _gem_push ;;
            query)          _gem_query ;;
            search)         _gem_search ;;
            server)         _gem_server ;;
            sources)        _gem_sources ;;
            specification)  _gem_specification ;;
            stale)          _gem_stale ;;
            uninstall)      _gem_uninstall ;;
            unpack)         _gem_unpack ;;
            update)         _gem_update ;;
            which)          _gem_which ;;
            *)           COMPREPLY=() ;;
        esac
    }

    complete -o default -o nospace -F _gem gem
fi
