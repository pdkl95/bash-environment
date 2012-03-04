##############################
###  MPLAYER HELPER SUITE  ###
##############################

# option defaults
: ${MPLAYERPROFILE:=m}
: ${MPLAYEROPT:=}
: ${GRATUITOUS_MPLAYER_HELPER_OUTPUT:=true}

######################################################
# first, a few things moved ovoer from ansicolor.sh
# that were really only being used here. Should really
# be expanded innto a full "GUI/Widget Toolkit"
pcolorln() {
    pcolor "$@"
    echo
}

function NC {
    color_name_to_ansi 'clear'
}

STRONG_MARKER_L="$(pcolor DARK!red '-')$(pcolor red '=')$(pcolor BOLD!red '<')"
STRONG_MARKER_R="$(pcolor BOLD!red '>')$(pcolor red '=')$(pcolor DARK!red '-')"
function strong_msg {
    echo "${STRONG_MARKER_L}$(pcolor BOLD!green ' '${1}' ')${STRONG_MARKER_R}"
}

function warn_msg {
    strong_msg "$(pcolor YELLOW 'WARNING:') $@"
}

function error_msg {
    strong_msg "$(pcolor RED 'ERROR:') $@"
}

BLANK_LINE="$(pcolor BLACK '')"
function blankln {
    # force some useless ANSI in, so it doesn't get eaten by bash
    echo "$BLANK_LINE"
}

# ... now back to MPlayer ...
##################################


declare -A MPHSTATIC=()
MP_BIN='' MP_NAMEPAD='' MP_BINOPT=''
[ $FIND ] || FIND=$(/usr/bin/which --show-dot --show-tilde find)

MPHSTATIC[HDR_LEFT]="$(pcolor BOLD!purple '------- ARGV')$(pcolor purple '[')"
MPHSTATIC[HDR_RIGHT]="$(pcolor purple ']')$(pcolorln BOLD!purple ' -------')"
MPHSTATIC[HDR]="${MPHSTATIC[HDR_LEFT]}$(pcolor YELLOW X)${MPHSTATIC[HDR_RIGHT]}"
MPHSTATIC[Q]="$(pcolor yellow \")"
MPHSTATIC[IN_Q]="${MPHSTATIC[Q]}$(pcolor BOLD!white X)${MPHSTATIC[Q]}"
MPHSTATIC[PURP_ARROW]="$(pcolor PURPLE ' => ')"
MPHSTATIC[ML_MARKER]="$(pcolor YELLOW "-=<")$(pcolor BOLD!white '*')$(pcolor YELLOW ">=-")"
MPHSTATIC[ML_MSG]="$(pcolor GREEN 'MOVIES FOUND')$(pcolor green ':') $(pcolor BOLD!cyan X)"
MPHSTATIC[DIVSEG]="$(pcolor yellow '----')${MPHSTATIC[ML_MARKER]}$(pcolor yellow '----')"
MPHSTATIC[DIVIDER]="${MPHSTATIC[DIVSEG]}$(pcolor yellow '-------PAD--------')${MPHSTATIC[DIVSEG]}"
MPHSTATIC[VBAR]="$(pcolor BOLD!purple '| ')"
MPHSTATIC[ENDCAP]="$(pcolor BOLD!purple '-------+ ')"
MPHSTATIC[CMDLINE_MSG]="$(pcolor BOLD!blue '*** ')$(pcolor cyan 'COMMAND LINE')$(pcolor BOLD!blue ' ***')"
MPHSTATIC[HANDOFF_MSG]="${MPHSTATIC[DIVSEG]}$(strong_msg 'Launching...')"
MPHSTATIC[FINISH_MSG]="${MPHSTATIC[DIVSEG]}$(strong_msg 'Player quit!')${MPHSTATIC[DIVIDER]}"

MPHSTATIC[SS_S1]="$(pcolor BOLD!purple '-------+ ')"
MPHSTATIC[SS_S2]="$(pcolor WHITE/purple 'SEARCH!')${MPHSTATIC[VBAR]}"
MPHSTATIC[SS_S3]="$(pcolor BOLD!purple '-------+ ')"
MPHSTATIC[SS_A]=" $(pcolor purple \\)$(pcolor PURPLE \\)$(pcolor BOLD!purple \\)$(pcolor BOLD!white/purple '  ')$(pcolor BOLD!white/PURPLE '/')${MPHSTATIC[VBAR]}"
MPHSTATIC[SS_B]="$(pcolor cyan/blue \\) $(pcolor purple \\)$(pcolor PURPLE \\)$(pcolor BOLD!purple \\)$(pcolor white/purple '  ')${MPHSTATIC[VBAR]}"
MPHSTATIC[SS_C]="$(pcolor CYAN/BLUE \\)$(pcolor cyan/blue \\) $(pcolor purple \\)$(pcolor PURPLE \\)$(pcolor BOLD!purple \\)$(pcolor white/purple ' ')${MPHSTATIC[VBAR]}"
MPHSTATIC[SS_D]="$(pcolor WHITE/blue /)$(pcolor CYAN/BLUE \\)$(pcolor cyan/blue \\) $(pcolor purple \\)$(pcolor PURPLE \\)$(pcolor BOLD!purple \\)${MPHSTATIC[VBAR]}"
MPHSTATIC[SS_E]="$(pcolor white/BLACK '>')$(pcolor $BOLD!PURPLE/blue '*')$(pcolor CYAN/BLUE '>')$(pcolor cyan/blue '>') $(pcolor purple \))$(pcolor PURPLE \))${MPHSTATIC[VBAR]}"
MPHSTATIC[SS_F]="$(pcolor WHITE/blue \\)$(pcolor CYAN/BLUE /)$(pcolor cyan/blue /) $(pcolor purple /)$(pcolor PURPLE /)$(pcolor BOLD!purple /)${MPHSTATIC[VBAR]}"
MPHSTATIC[SS_G]="$(pcolor CYAN/BLUE /)$(pcolor cyan/blue /) $(pcolor purple /)$(pcolor PURPLE /)$(pcolor BOLD!purple /)$(pcolor white/purple ' ')${MPHSTATIC[VBAR]}"
MPHSTATIC[SS_H]="$(pcolor cyan/blue /) $(pcolor purple /)$(pcolor PURPLE /)$(pcolor BOLD!purple /)$(pcolor white/purple '  ')${MPHSTATIC[VBAR]}"
MPHSTATIC[SS_I]=" $(pcolor purple /)$(pcolor PURPLE /)$(pcolor BOLD!purple /)$(pcolor BOLD!white/purple '  ')$(pcolor BOLD!white/PURPLE '\')${MPHSTATIC[VBAR]}"
MPHSTATIC[SS_J]="$(pcolor purple \()$(pcolor PURPLE \()$(pcolor BOLD!purple \()$(pcolor white/purple ' ')$(pcolor white/purple '*')$(pcolor BOLD!white/PURPLE '>')$(pcolor WHITE/purple '*')${MPHSTATIC[VBAR]}"

function wrapIFS {
    local newIFS="$1" ; shift
    [[ $newIFS = '\n' ]] && newIFS=$'\012'
    local CMD="$1" ; shift

    local oldIFS="$IFS"
    IFS="$newIFS"
    if [ $# -eq 0 ] ; then
        $CMD
    else
        for i in $*; do
            IFS="$oldIFS"
            $CMD "$i"
            IFS="$newIFS"
        done
    fi
    IFS="$oldIFS"
}

function draw_next_row {
    local S="${MPHSTATIC[SS_${MPHSTATE}]}"
    echo "$S$@"

    case ${MPHSTATE} in
    S1) export MPHSTATE='S2' ;;
    S2) export MPHSTATE='S3' ;;
    S3) export MPHSTATE='G'  ;;
     A) export MPHSTATE='B'  ;;
     B) export MPHSTATE='C'  ;;
     C) export MPHSTATE='D'  ;;
     D) export MPHSTATE='E'  ;;
     E) export MPHSTATE='F'  ;;
     F) export MPHSTATE='G'  ;;
     G) export MPHSTATE='H'  ;;
     H) export MPHSTATE='I'  ;;
     I) export MPHSTATE='J'  ;;
     J) export MPHSTATE='A'  ;;
    esac
}

function draw_field_infobox {
    local NUM="$1"; shift

    function draw_optrow {
        draw_next_row "$(pcolor green $1)${MPHSTATIC[PURP_ARROW]}$2"
    }

    draw_next_row "${MPHSTATIC[HDR]/X/$NUM}"
    draw_optrow 'INPUTSTR' "${MPHSTATIC[IN_Q]/X/$IN_ORIG}"
    [[ "$IN_ORIG" != "$IN" ]] && draw_optrow 'REALPATH' "$(pcolor blue $IN)"

    function reescape_cmd {
        sed -re 's/([$`\*'\"\!\''()|])/\\\1/g'
    }

    function wrap_to_right_side {
        fold -w $(expr $COLUMNS - 21) - | sed -e '1! s/^/~~~/gm'
    }

    function draw_padded_line {
        if [[ "$@" =~ ^~~~(.+)$ ]] ; then
            draw_next_row "            $(pcolorln cyan ${BASH_REMATCH[1]})"
        else
            draw_optrow 'FIND_CMD' "$(pcolorln cyan $@)"
        fi
    }

    local CMD=$(echo $* | wrap_to_right_side)
    #local CMD=$(echo $* | reescape_cmd)

    wrapIFS \\n draw_padded_line "$CMD"

    draw_next_row
}

function add_to_find {
    local name="$1" ; shift

    case $name in
    SRC)  FIND_SRC=(  "${FIND_SRC[@]}"  "$@" ) ;;
    OPT)  FIND_OPT=(  "${FIND_OPT[@]}"  "$@" ) ;;
    EXPR) FIND_EXPR=( "${FIND_EXPR[@]}" "$@" ) ;;
    esac
}

function add_wildcards {
    local DIR="$1" ; shift
    local STR="$1" ; shift

    if   [[ "$STR" =~ \.[^.]+$ ]] ; then  # .foo$
        add_to_find OPT '-regex' .*"${STR}"$
    elif [[ "$STR" =~ ^[.?.].* ]] ; then  # *foo* ?foo*
        add_to_find OPT '-regex' .*"${STR#\?}".*
    else                                #  foo*
        local -i N=$(ls $DIR/$STR* 2> /dev/null | wc -l)
        if [ $N -ne 0 ] ; then
            add_to_find OPT '-maxdepth' '1'
        fi
        local RE="^$DIR/${STR//\*/[^/]*}.*"
        add_to_find EXPR '-regex' "$RE"
    fi
}

function generate_mph_cmdline {
    local X="$1"
    local -a FIND_SRC=() FIND_OPT=() FIND_EXPR=()

    add_to_find EXPR '-regextype' 'posix-extended'

    if   [ -d "$X" ] ; then
        add_to_find SRC "$X"
    elif [ -f "$X" ] ; then
        add_to_find SRC "$X"
    else
        if [[ "$X" =~ / ]] ; then
            IN="$(readlink -f $(dirname "$X"))"
            X="$(basename "$X")"
        else
            IN="$PWD"
        fi
        add_to_find SRC "$IN/"
        add_wildcards "$IN" "$X"
    fi

    #add_to_find EXPR '-regex' '.*\.\(avi\|mkv\|flv\|mp4\|m4v\|mov\|mpg\|ogm\|wmv\)'\\\'
    add_to_find EXPR '-type' 'f'

    echo "${FIND_SRC[@]} ${FIND_OPT[*]} ${FIND_EXPR[*]}"
}

function list_movies_in {
    local OUT=$1 ; shift
    local NUM=$1 ; shift
    local IN="$1" IN_ORIG="$1" ; shift

    local PREFIX="${PWD[@]}/"
    [[ "$IN" =~ ^/.* ]] || IN="./$IN"

    local -a FINDCMD=$(generate_mph_cmdline "$IN")

    $GRATUITOUS_MPLAYER_HELPER_OUTPUT && draw_field_infobox $NUM "$FINDCMD"

    function run_find {
        $FIND ${FINDCMD[@]} -print0 | sort -z >> $OUT
    }

    wrapIFS ' ' run_find
}

function show_movielist_items {
    echo "${MPHSTATIC[DIVIDER]/PAD}"
    xargs -0 --max-args=1 echo < "$1"
    echo "${MPHSTATIC[DIVIDER]/PAD}"
}

function show_movielist {
    local count=$(cat "$1" | tr -d [:print:] | wc -c)
    local LINES=$(show_movielist_items "$1")

    wrapIFS \\n draw_next_row $LINES

    echo "${MPHSTATIC[ENDCAP]}${MPHSTATIC[ML_MSG]/X/$count}"
    blankln
}

run_mplayer_once() {
    $*
}

run_mplayer_once_in_color() {
    col=$(expr $COLUMNS - 80)
    pad=''
    while [[ $col -gt 0 ]]; do
        pad="-$pad"
        col=$(expr $col - 1)
    done

    echo "VERBOSITY=${verbosity}"
    echo
    echo "${MPHSTATIC[CMDLINE_MSG]}"
    pcolorln DARK!white $@
    echo -n "${MPHSTATIC[HANDOFF_MSG]/MOVIEPLAYER/$MP_BIN}"
    pcolorln yellow "$MPNAMEPAD${MPHSTATIC[DIVIDER]/PAD/$pad}"

    run_mplayer_once "$@"

    echo "${MPHSTATIC[FINISH_MSG]/PAD/$pad}"
}

function list_player_options {
    while [ $# -gt 0 ]; do
        local a="$1" ; shift
        if [[ "$a" =~ ^-.* ]] ; then
            echo $arg $1
            shift
        fi
    done
}

function list_movies_into_newtemp {
    local ORIG="$1" ; shift
    local NUM="$1"  ; shift

    local T2="$ORIG-$NUM"

    function cleanup_t2 {
        [ -f "$T2" ] && command rm -f -- "$T2"
    }
    trap cleanup_t2 RETURN
    echo "newtemp> $@" > /dev/null
    list_movies_in $T2 $NUM "$@"
    show_movielist $T2
    cat $T2 >> $ORIG
}

function list_movies_into_tempfile {
    local T1="$1" ; shift
    local -i FIELDNUM=0
    while [ $# -gt 0 ]; do
        local arg="$1" ; shift
        echo "ARG> $arg" > /dev/null
        if [[ "$arg" =~ ^-.* ]] ; then
            shift
        else
            export MPHSTATE='S1'
            FIELDNUM=$FIELDNUM+1
            if $GRATUITOUS_MPLAYER_HELPER_OUTPUT ; then
                list_movies_into_newtemp $T1 $FIELDNUM "$arg"
            else
                list_movies_in $T1 $FIELDNUM "$arg"
            fi
            echo -ne '\000' >> $T1
        fi
    done
}

function mplayer_launch_helper {
    if [ $# -eq 0 ]; then
        warn_msg "$(pcolor BOLD!white 'Assuming you meant:') ${MPHSTATIC[Q]}$(pcolor BOLD!yellow $PWD)${MPHSTATIC[Q]}"
        mplayer_launch_helper $PWD
        return $?
    fi

    local TMP="$(tempfile)"

    function cleanup_tmp {
        [ -f "$TMP" ] && command rm -f -- "$TMP"
    }
    trap cleanup_tmp RETURN

    local PLAYOPT=$(list_player_options "$@")
    list_movies_into_tempfile "$TMP" "$@"

    local CUR_BIN="${MP_BIN:-mplayer}"
    local CUR_OPT=""
    [ -n "${MP_BINOPT}"      ] && CUR_OPT="${MP_BINOPT} ${CUR_OPT}"
    [ -n "${MPLAYERPROFILE}" ] && CUR_OPT="-profile ${MPLAYERPROFILE} ${CUR_OPT}"
    [ -n "${MPLAYEROPT}"     ] && CUR_OPT="${CUR_OPT} ${MPLAYEROPT}"
    [ -n "${PLAYOPT}"        ] && CUR_OPT="${CUR_OPT} ${PLAYOPT}"

    if [ -s $TMP ] ; then
        local C=''
        $GRATUITOUS_MPLAYER_HELPER_OUTPUT && C='_in_color'
        local MPCMDS="$(xargs -0 echo ${CUR_BIN} ${CUR_OPT} < $TMP)"
        wrapIFS \\n run_mplayer_once$C "$MPCMDS"
    else
        echo "Got nothing."
    fi
}

mplayer_launch_helper_wrap() {
    local MP_BIN="$1" MP_NAMEPAD="$2" MP_BINOPT="$3"
    shift 3
    mplayer_launch_helper "$@"
}

#######################################################################
# exported wrappers

### first, wrap the basic executables so they load binary-specific configs
for x in mplayer mplayer2 ; do
    eval "$x() { command $x -include \"${HOME}/.mplayer/$x/local.conf\" \"\$@\"; }"
done

### then, specify the actual user-interaction shortcuts

mplayer2launch() {
    local MP_BIN="mplayer2"
    local MP_NAMEPAD=""
    mplayer_launch_helper "$@"
}

m() {
    local MP_BINOPT=''
    mplayer2launch "$@"
}
mm() {
    local MP_BINOPT='-v'
    mplayer2launch "$@"
}
m3d() {
    local MP_BINOPT='-profile m.3d -v'
    mplayer2launch "$@"
}
mdbg()   {
    local MP_BINOPT='-v -v -v -msglevel demux=0'
    mplayer2launch "$@"
}

mn() {
    mplayer_launch_helper_wrap mplayer '-' '-quiet' "$@"
}
