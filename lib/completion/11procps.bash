
# a variant of _pnames() that returns the "comm" field form ps,
# instead ofthe larger "command' field that includes all of the args.
# Also, the "comm" field is truncated at times in a manner that
# is expected when used with "pkill"/etc


_pnames_short () {
    COMPREPLY=($( compgen -X '<defunct>' -W '$( command ps axo comm= | \
        sed -e "s/ .*//" -e "s:.*/::" -e "s/:$//" -e "s/^[[(-]//" \
            -e "s/[])]$//" | sort -u )' -- "$cur" ))
}

_killall () { 
    local cur;
    COMPREPLY=();
    _get_comp_words_by_ref cur;
    if [[ $COMP_CWORD -eq 1 && "$cur" == -* ]]; then
        _signals;
    else
        _pnames_short;
    fi;
    return 0
}

_pgrep() { 
    local cur;
    COMPREPLY=();
    _get_comp_words_by_ref cur;
    _pnames_short;
    return 0
}
