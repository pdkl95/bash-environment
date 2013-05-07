
demo-ansi-raw-escapes() {
    local outerstyle="$1"
    #local -a styles=( 0 1 4 5 7 )
    local -a styles=( 0 1 2 3 4 5 6 7 )

    for a in "${styles[@]}" ; do
        if [[ "${outerstyle}" == "${a}" ]] ; then
            echo "(redundant style)"
        fi
        a="${outerstyle};${a}"
        echo "(style: \"$a\") "
        for (( f=0; f<8; f++ )) ; do
            for (( b=0; b<8; b++ )) ; do
                #echo -ne "f=$f b=$b"
                echo -ne "\\033[${a};3${f};4${b}m"
                echo -ne "\\\\033[${a};3${f};4${b}m"
                echo -ne "\\033[0m "
            done
            echo
        done
        echo
    done
    echo
}

demo-ansi-raw-pair-escapes() {
    local -a styles=( 0 1 2 3 4 5 6 7 )

    for s in "${styles[@]}" ; do
        echo "    ---==*==---  Style Pairs: ${s};\${0..7}  ---==*==---"
        echo
        demo-ansi-raw-escapes "$s"
        echo
    done
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

demo-figlet-fonts() {
    FIGDIR=/usr/share/figlet
    local -i total=$(ls $FIGDIR/*.flf | wc -l)
    local -i pos=0
    for f in $FIGDIR/*.flf ; do
        (( pos++ ))
        f="${f%.flf}"
        f="${f##*/}"

        echo
        echo "$pos/$total  ->  $f" | boxes -p h2
        echo fooBar QUUX | figlet -d "$FIGDIR" -f $f
    done
}

demo-toilet-fonts() {
    unset NOCOLOR_PIPE

    #FONTDIR=/usr/share/figlet
    FONTDIR="${HOME}/.cw/fonts"
    unset
    local -i total=$(ls "$FONTDIR"/*.{tlf,flf} | wc -l)
    local -i pos=0
    for f in "$FONTDIR"/*.{tlf,flf} ; do
        (( pos++ ))
        f="${f%.flf}"
        f="${f##*/}"

        echo
        echo "$pos/$total  ->  $f" | boxes -p h2
        echo "[[ toilet -d $FONTDIR -f $f ]]"
        echo fooBar QUUX | toilet -d "$FONTDIR" -f $f
    done
}
