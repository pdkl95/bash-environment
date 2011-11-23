# -*- mode: sh -*-

###############################
###  general utils/helpers  ###
###############################

function parse_git_dirty {
    [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit (working directory clean)" ]] && echo "*"
}

function parse_git_branch {
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/[\1$(parse_git_dirty)]/"
}

function e {
    #export GDK_NATIVE_WINDOWS=1
    emacsclient --create-frame --no-wait --alternate-editor="/usr/bin/emacs" "$@" >& /dev/null & disown
#    /usr/bin/emacsclient -c "$@" >& /dev/null & disown
}

#function r {
#    emacsclient -e "(remember-other-frame)"
#}


function xtitle {      # Adds some text in the terminal frame.
    case "$TERM" in
        *term | rxvt)
            echo -ne "\033]0;$*\007" ;;
        *)
            ;;
    esac
}

function man {
    for i ; do
        xtitle man -a $(basename $1|tr -d .[:digit:])
        command man -a "$i"
    done
}

# auto-background helpers
#function azureus {
#    command azureus "$@" & disown
#}
function xpdf {
    command xpdf "$@" & disown
}

# Find a file with a pattern in name:
function ff { find . -type f -iname '*'$*'*' -ls ; }

# Find a file with pattern $1 in name and Execute $2 on it:
function fe { find . -type f -iname '*'${1:-}'*' -exec ${2:-file} {} \;  ; }


# Swap 2 filenames around, if they exist
function swap {
    local TMPFILE=tmp.$$

    [ $# -ne 2 ] && echo "swap: 2 arguments needed" && return 1
    [  ! -e $1 ] && echo "swap: $1 does not exist"  && return 1
    [  ! -e $2 ] && echo "swap: $2 does not exist"  && return 1

    mv "$1" $TMPFILE
    mv "$2" "$1"
    mv $TMPFILE "$2"
}


function extract {      # Handy Extract Program.
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xvjf $1     ;;
            *.tar.gz)    tar xvzf $1     ;;
            *.bz2)       bunzip2 $1      ;;
            *.rar)       unrar x $1      ;;
            *.gz)        gunzip $1       ;;
            *.tar)       tar xvf $1      ;;
            *.tbz2)      tar xvjf $1     ;;
            *.tgz)       tar xvzf $1     ;;
            *.zip)       unzip $1        ;;
            *.Z)         uncompress $1   ;;
            *.7z)        7z x $1         ;;
            *)           echo "'$1' cannot be extracted via >extract<" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

function my_ps {
    ps --deselect --ppid 2 "$@" -o pid,user,%cpu,%mem,nlwp,stat,bsdstart,vsz,rss,cmd --sort=bsdstart ;
}

function my_ps_tree {
    ps_custom f "$@"
}

function my_ps_tree_wide {
    my_ps_tree ww
}

# Repeat n times command.
function repeat {
    local i max
    max=$1; shift;
    for ((i=1; i <= max ; i++)); do  # --> C-like syntax
        eval "$@";
    done
}


# See 'killps' for example of use.
function ask {
    echo -n "$@" '[y/n] ' ; read ans
    case "$ans" in
        y*|Y*) return 0 ;;
        *)     return 1 ;;
    esac
}

function dircmp {
    diff -qrsl $1 $2 | sort -r | \
        awk '/differ/ {
           print "different  ",$2;
         }
         /are identical/ {
           print "same       ",$2;
         }
         /Only in/ {
           print $0;
         }'
}






