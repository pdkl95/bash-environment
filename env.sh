# various project-wide directory roots
export PDKL_SCRIPT_ROOT="${PDKL_HOME}/src/scripts"
export MINECRAFT_ROOT="${PDKL_HOME}/games/minecraft"

add_project_root "${PDKL_SCRIPT_ROOT}"
add_project_root "${MINECRAFT_ROOT}"

##################################################
# enable color if possilbe
is_defined USE_ANSI_COLOR || (
    case ${TERM:-dummy} in
        linux*|con80*|con132*|console|xterm*|vt*|screen*|putty|Eterm|dtterm|ansi|rxvt|gnome*|*color*)
            USE_ANSI_COLOR=true ;;
        *)  USE_ANSI_COLOR=false  ;;
    esac
)


if ${USE_ANSI_COLOR} ; then
    AUTOCOLOR=' --color=auto'

    # Reset
    CCnil='\e[0m'       # Text Reset

    # Regular Colors
    CCblack='\e[0;30m'        # Black
    CCred='\e[0;31m'          # Red
    CCgreen='\e[0;32m'        # Green
    CCyellow='\e[0;33m'       # Yellow
    CCblue='\e[0;34m'         # Blue
    CCpurple='\e[0;35m'       # Purple
    CCcyan='\e[0;36m'         # Cyan
    CCwhite='\e[0;37m'        # White

    # Bold
    CCBblack='\e[1;30m'       # Black
    CCBred='\e[1;31m'         # Red
    CCBgreen='\e[1;32m'       # Green
    CCByellow='\e[1;33m'      # Yellow
    CCBblue='\e[1;34m'        # Blue
    CCBpurple='\e[1;35m'      # Purple
    CCBcyan='\e[1;36m'        # Cyan
    CCBwhite='\e[1;37m'       # White

    # Underline
    CCUblack='\e[4;30m'       # Black
    CCUred='\e[4;31m'         # Red
    CCUgreen='\e[4;32m'       # Green
    CCUyellow='\e[4;33m'      # Yellow
    CCUblue='\e[4;34m'        # Blue
    CCUpurple='\e[4;35m'      # Purple
    CCUcyan='\e[4;36m'        # Cyan
    CCUwhite='\e[4;37m'       # White

    # Background
    CCon_black='\e[40m'       # Black
    CCon_red='\e[41m'         # Red
    CCon_green='\e[42m'       # Green
    CCon_yellow='\e[43m'      # Yellow
    CCon_blue='\e[44m'        # Blue
    CCon_purple='\e[45m'      # Purp/le
    CCon_cyan='\e[46m'        # Cyan
    CCon_white='\e[47m'       # White

    # High Intensty
    CCIblack='\e[0;90m'       # Black
    CCIred='\e[0;91m'         # Red
    CCIgreen='\e[0;92m'       # Green
    CCIyellow='\e[0;93m'      # Yellow
    CCIblue='\e[0;94m'        # Blue
    CCIpurple='\e[0;95m'      # Purple
    CCIcyan='\e[0;96m'        # Cyan
    CCIwhite='\e[0;97m'       # White

    # Bold High Intensty
    CCBIblack='\e[1;90m'      # Black
    CCBIred='\e[1;91m'        # Red
    CCBIgreen='\e[1;92m'      # Green
    CCBIyellow='\e[1;93m'     # Yellow
    CCBIblue='\e[1;94m'       # Blue
    CCBIpurple='\e[1;95m'     # Purple
    CCBIcyan='\e[1;96m'       # Cyan
    CCBIwhite='\e[1;97m'      # White

    # High Intensty backgrounds
    CCon_Iblack='\e[0;100m'   # Black
    CCon_Ired='\e[0;101m'     # Red
    CCon_Igreen='\e[0;102m'   # Green
    CCon_Iyellow='\e[0;103m'  # Yellow
    CCon_Iblue='\e[0;104m'    # Blue
    CCon_Ipurple='\e[10;95m'  # Purple
    CCon_Icyan='\e[0;106m'    # Cyan
    CCon_Iwhite='\e[0;107m'   # White
else
    AUTOCOLOR=''
    CCnil=''
    for x in CC{,B,U,I,on_,BI,on_I}{black,red,green,yellow,blue,purple,cyan,white}
    do
        declare -- "$x"=""
    done
fi


##################################
# Locales/i18n
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export LC_COLLATE="C"
export LC_CTYPE="C"


##################################################
# set some defaults


: ${EDITOR:=$(is_cmd zile && echo "zile" || echo 'vim')}
: ${VISUAL:=${EDITOR}}

is_cmd less && (
    export PAGER=less
    if ${USE_ANSI_COLOR}; then
        is_cmd lesspipe && (
        # Less Colors for Man Pages
            export LESS_TERMCAP_mb=$'\E[01;31m'       # begin blinking
            export LESS_TERMCAP_md=$'\E[01;38;5;74m'  # begin bold
            export LESS_TERMCAP_me=$'\E[0m'           # end mode
            export LESS_TERMCAP_se=$'\E[0m'           # end stdout-mode
            export LESS_TERMCAP_so=$'\E[38;5;246m'    # begin stdout-mode - infobox
            export LESS_TERMCAP_ue=$'\E[0m'           # end underline
            export LESS_TERMCAP_us=$'\E[04;38;5;146m' # begin underline
            export LESSCHARSET='latin1'
            export LESSOPEN='|gzip -cdfq %s | `type -P lesspipe` %s 2>&-'
            export LESS='-i -N -w  -z-4 -e -M -X -J -s -R -P%t?f%f :stdin .?pb%pb\%:?lbLine %lb:?bbByte %bb:-...'
        ) || (
            export LESSCOLOR=yes
        )
    fi
) || (
    export PAGER=more
)


export TIMEFORMAT=$'\nreal %3R\tuser %3U\tsys %3S\tpcpu %P\n'

export FIGNORE='.o:~'
export HISTFILE="${PDKL_BASHDIR}/history.list"
export HISTTIMEFORMAT="%H:%M > "
export HISTIGNORE="&:bg:fg:ll:h"
export HISTSIZE=2000

export RUBYOPT=""
#export GEM_HOME="$HOME/.gem"
#export GEM_PATH="$GEM_HOME:/usr/lib/ruby/gems/1.9.1"
#add_path_prefix "$HOME/.gem/bin"

#export GOROOT="$HOME/src/go"
#export GOOS="linux"
#export GOARCH="amd64"
#export GOBIN="$HOME/bin"
