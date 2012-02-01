###################################################
###  Locales (Internationalizatioo aka "i18n")  ###
###################################################

# never set this; it *OVERRIDES* *EVERYTHING*
# related to locales, often screwing up
# stuff that still depended on some specific
# (probably "C"/ASCII) property.
unset LC_ALL
# To set a default, instad use LANG which *NEVER*
# forces it';s value when there is something more speciic.
#
# Thhe default should almost always be a UTF-8
# variant if it exists. So uses your default value
# for as an input, but tries to upgrade the character
# set porttion if needed.
if [[ "${LANG:=en_US.utf8}" =~ '[[:lower:]]{2}(_[[:upper:]]{2}(\.[uU][tT][fF].?)?)?8$' ]] ; then
    :  # good - it amtches, no need to get invlived
else
    export LANG="$(locale -a | grep -i ^${LANG%%.*}.*\.utf8 | head -n 1)"
    if [[ -z "$LANG" ]] ; then
        echoerr "WARNING: Couldn't find a UTF8 compatible locsle! You should fix that or fix whatever is wrong with \$LANG/etc!"
    fi
fi


# default sort order to the ASCII-order sort that
# is still so common.
# but not recommended unless you kno how all the
export LC_COLLATE="C"
#
# default to 1-octet-per-"charcter" strings as well
# as that affects the formating, layout, etc, of pretty
# much all formatting everywehere...
export LC_CTYPE="C"
#
# <div class="rant">
#   <h3>fix your software!</h3>
#   There is no excuse for *ANY* # software to not
#   support UTF-8 straight. By default. Always.
#   <sidebar>
#     Iincidently, as a consequence of this, there is no
#     way to iterate over UTF-8, like people do frequently
#     with ascii. "One UNICODE CodePoint" is not a synonym
#     for "1 printable GLYPH", "Character", or "fixed amount"
#     of data (memory)." And in thoday's internet, the odds
#     of having to deal with asorted random areas of UNICODE
#     with strange properties is quickly approaching 1.0
#   </siebar>
# </div)
#
# The rese we leave alone... they either get overriden
# outside of this script, or they get the default $LANG value
