if type -p gem 2>/dev/null ; then

    function _gem_all_names {
        #echo "NAME"
        return 0;
    }

    function _gem_installed_names {
        echo "NAME"
    }

    function _gem_all_name_versions {
        echo "NAME"
    }

    function _gem {
        local cur subcommand completions
        COMPREPLY=()
        cur="${COMP_WORDS[COMP_CWORD]}"

        subcommand=''
        if [[ "${COMP_CWORD}" -gt 1 ]] ; then
            subcommand="${COMP_WORDS[1]}"
            echo "<<<$subcommand>>>"
        fi

        COMMANDS='build cert check cleanup contents dependency environment fetch generate_index help install list lock mirror outdated owner pristine pushh query rdoc search server sources speciication stale uninstall unpack update which'

        GEM_OPTIONS='\
        -h --help\
        -v --version'

        COMMON_OPTIONS='\
        -h --help\
        -V --verbose --no-verbose\
        -q --quiet\
        --config-file\
        --backtrace\
        --debug'

        LOCAL_REMOTE_OPTIONS='\
        -l --local\
        -r --remote\
        -b --both\
        -B --bulk-threshold\
        --source\
        -p --http-proxy --no-http-proxy\
        -u --update-sources --no-update-sources'

        INSTALL_UPDATE_OPTIONS='\
        -i --install-dir\
        -n --bindir\
        -d --rdoc --no-rdoc\
           --ri --no-ri\
        -E --env-shebang --no-env-shebang\
        -f --force --no-force\
        -t --test --no-test\
        -w --wrappers --no-wrappers\
        -P --trust-policy\
           --ignore-dependencies\
        -y --include-dependencies\
           --format-executable --no-format-executable'

        CERT_OPTIONS='\
        -a -add\
        -l --list\
        -r --remove\
        -b --build\
        -C --certificate\
        -K --private-key\
        -s --sign'

        CHECK_OPTIONS='\
        --verify\
        -a --alien\
        -t --test\
        -v --version'

        CLEANUP_OPTIONS='\
        -d --dry-run'

        CONTENTS_OPTIONS='\
        -v --version\
        -s --spec-dir\
        -l --lib-only --no-lib-only'

        DEPENDENCY_OPTIONS='\
        -v --version\
        --platform\
        -R --reverse-dependencies --no-reverse-dependencies\
        -p --pipe'

        ENVIRONMENT_OPTIONS='\
        packageversion\
        gemdir\
        gempath\
        version\
        remotesources'

        FETCH_OPTIONS='\
        -v --version\
        --platform\
        -B --bulk-threshold\
        -p --http-proxy --no-http-proxy\
        --source'

        GENERATE_INDEX_OPTIONS='\
        -d --directory'

        HELP_OPTIONS="commands examples platforms $COMMANDS"

        INSTALL_OPTIONS='\
        --platform\
        -v --version'

        LIST_OPTIONS='\
        -i --installed --no-installed\
        -v --version\
        -d --details --no-details\
        --versions --no-versions\
        -a --all'

        LOCK_OPTIONS='\
        -s --strict --no-strict'

        MIRROR_OPTIONS=''

        OUTDATED_OPTIONS='\
        --platform'

        PRISTINE_OPTIONS='\
        --all\
        -v --version'

        QUERY_OPTIONS='\
        -i --installed --no-installed\
        -v --version\
        -n --name-matches\
        -d --details --no-details\
        --versions --no-versions\
        -a --all'

        RDOC_OPTIONS='\
        --all\
        --rdoc --no-rdoc\
        --ri --no-ri\
        -v --version'

        SEARCH_OPTIONS='\
        -i --installed --no-installed\
        -v --version\
        -d --details --no-details\
        --versions --no-versions\
        -a --all'

        SERVER_OPTIONS='\
        -p --port\
        -d --dir\
        --daemon --no-daemon'

        SOURCES_OPTIONS='\
        -a --add\
        -l --list\
        -r --remove\
        -u --update\
        -c --clear-all'

        SPECIFICATION_OPTIONS='\
        -v --version\
        --platform\
        --all'

        UNINSTALL_OPTIONS='\
        -a --all --no-all\
        -i --ignore-dependencies --no-ignore-dependencies\
        -x --executables --no-executables\
        -i --install-dir\
        -n --bindir\
        -v --version\
        --platform'

        UNPACK_OPTIONS='\
        --target\
        -v --version'

        UPDATE_OPTIONS='\
        --system\
        --platform'

        WHICH_OPTIONS='\
        -a --all --no-all\
        -g --gems-first --no-gems-first'

        case "${subcommand}" in
            build)
                completions="$COMMON_OPTIONS"
                ;;
            cert)
                completions="$COMMON_OPTIONS $CERT_OPTIONS"
                ;;
            check)
                completions="$COMMON_OPTIONS $CHECK_OPTIONS"
                ;;
            cleanup)
                completions="$COMMON_OPTIONS $CLEANUP_OPTIONS `_gem_installed_names`"
                ;;
            contents)
                completions="$COMMON_OPTIONS $CONTENTS_OPTIONS `_gem_installed_names`"
                ;;
            dependency)
                completions="$COMMON_OPTIONS $LOCAL_REMOTE_OPTIONS $DEPENDENCY_OPTIONS `_gem_all_names`"
                ;;
            environment)
                completions="$COMMON_OPTIONS $ENVIRONMENT_OPTIONS"
                ;;
            fetch)
                completions="$COMMON_OPTIONS $FETCH_OPTIONS `_gem_all_names`"
                ;;
            generate_index)
                completions="$COMMON_OPTIONS $GENERATE_INDEX_OPTIONS"
                ;;
            help)
                completions="$COMMON_OPTIONS $HELP_OPTIONS"
                ;;
            install)
                completions="$COMMON_OPTIONS $INSTALL_UPDATE_OPTIONS $LOCAL_REMOTE_OPTIONS $INSTALL_OPTIONS `_gem_all_names`"
                ;;
            list)
                completions="$COMMON_OPTIONS $LOCAL_REMOTE_OPTIONS $LIST_OPTIONS"
                ;;
            lock)
                completions="$COMMON_OPTIONS $LOCK_OPTIONS `_gem_all_name_versions`"
                ;;
            mirror)
                completions="$COMMON_OPTIONS $MIRROR_OPTIONS"
                ;;
            outdated)
                completions="$COMMON_OPTIONS $LOCAL_REMOTE_OPTIONS $OUTDATED_OPTIONS"
                ;;
            pristine)
                completions="$COMMON_OPTIONS $PRISTINE_OPTIONS `_gem_installed_names`"
                ;;
            query)
                completions="$COMMON_OPTIONS $LOCAL_REMOTE_OPTIONS $QUERY_OPTIONS"
                ;;
            rdoc)
                completions="$COMMON_OPTIONS $RDOC_OPTIONS `_gem_installed_names`"
                ;;
            search)
                completions="$COMMON_OPTIONS $LOCAL_REMOTE_OPTIONS $SEARCH_OPTIONS"
                ;;
            server)
                completions="$COMMON_OPTIONS $SERVER_OPTIONS"
                ;;
            sources)
                completions="$COMMON_OPTIONS $SOURCES_OPTIONS"
                ;;
            specification)
                completions="$COMMON_OPTIONS $LOCAL_REMOTE_OPTIONS $SPECIFICATION_OPTIONS `_gem_all_names`"
                ;;
            stale)
                completions="$COMMON_OPTIONS"
                ;;
            uninstall)
                completions="$COMMON_OPTIONS $UNINSTALL_OPTIONS `_gem_installed_names`"
                ;;
            unpack)
                completions="$COMMON_OPTIONS $UNPACK_OPTIONS `_gem_installed_names`"
                ;;
            update)
                completions="$COMMON_OPTIONS $LOCAL_REMOTE_OPTIONS $INSTALL_UPDATE_OPTIONS $UPDATE_OPTIONS `_gem_installed_names`"
                ;;
            which)
                completions="$COMMON_OPTIONS $WHICH_OPTIONS"
                ;;
            *)
                completions="$COMMANDS $GEM_OPTIONS"
                ;;
        esac

        COMPREPLY=($(compgen -W "${completions}" -- "${cur}"))
        return 0
    }
    complete -o default -F _gem gem

fi
