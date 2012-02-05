
demo-ansi-raw-escapes() {
    for a in 0 1 4 5 7; do
        echo "a=$a "
        for (( f=0; f<=9; f++ )) ; do
            for (( b=0; b<=9; b++ )) ; do
                #echo -ne "f=$f b=$b"
                echo -ne "\\033[${a};3${f};4${b}m"
                echo -ne "\\\\\\\\033[${a};3${f};4${b}m"
                echo -ne "\\033[0m "
            done
            echo
        done
        echo
    done
    echo
}

demo-color-macros() {
    local mlist mchr clist="" max colsperstack stackwidth stackmax stacklimit
    local mlist="M D B"
    if [[ "$1" != "-c" ]] ; then
        shift
        ek
    else
        mlist="${mlist} U R"
        if [[ "$1" == "-f" ]] ; then
            shift
            mlist="${mlist} I C"
        fi
    fi
    mchr="$(echo "$mlist" | tr -d ' ')"
    colsperstack=${#mchr}

    (( max=8 ))

    (( stackwidth=colsperstack*max ))
    (( stackmax=COLUMNS/stackwidth ))

    (( stacklimit=2*(stackmax/2) ))

    for c in "bk rd gr yl bl pr cy wh"; do
        clist="$clist $c $(upcase $c)"
    done

    for bg in $clist; do
        local stack=0
        for fg in $clist; do
            local line=""
            local linelen newlen
            (( linelen=0 ))
            for mode in $mlist; do
                local C="${mode}:${fg}/${bg}"
                local S="$C"
                local Slen="${#S}" Plen newlen
                (( Plen=max-Slen ))
                local P=$(printf "%${Plen}s")
                (( newlen=linelen+max ))
                if (( $newlen >= $COLUMNS )) ; then
                    echo "$line"
                    line=""
                    (( linelen=0 ))
                else
                    (( linelen=newlen ))
                fi
                line="${line}$(pcolor "$C" "$S$P")"
            done
            echo -ne "$line"
            (( linelen=0 ))
            (( stack++ ))
            if (( stack >= stacklimit )) ; then
                (( stack=0 ))
                echo
                #echo --
            fi
        done
        #echo "    <<< BG >>>   "
    done
}



demo-color-stripe256() {
    local i j x y
    for i in {0..15}; do
        for j in {0..15}; do
            (( x=(16*j)+i ))
            (( y=255-x ))
            #(( x=(x+16)%256 ))
            #(( y=(y+16)%256 ))
            _Cff 0
            _Cbb $x
            echo -n ' X?'
            _C00
            echo -n ' '
            _Cff $x
            printf "%03d " $x
            _Cff $y
            _Cbb $x
            printf "%03d" $y
            _C00
            echo -n '   '
        done
        echo
    done
}


demo-figlet() {
    [[ "$#" -gt "0" && $1 == *-h* ]] && echo "Usage: $FUNCNAME word" && return 2
    for a in /usr/share/figlet/*.flf; do
        r=`basename ${a%%.flf}`
        echo -e "${r}"
        figlet -t -f "$r" "$1"
    done
}
