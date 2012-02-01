#!/bin/bash

###################
# Install Options #
###################

### Minecraft Dir - defaults to .minecraft in your
###                 in yuur home directory.
: ${MINECRAFT:=${HOME}/.minecraft}
#MINECRAFT=/some/other/path

### minecraf.jar - As an alternative to the abovve,
###                you can speciy where to find the
###                actual minecraft.jar to modify.
###                That's the only reason the minecraft
###                directory anyway. This defaults to
###                relying on the probably-easier-to-guess
###                previous version, so it starts with
###                the default of: ${MINECRAFT}/bin/minecraft.jar
: ${MINECRAFT_JAR:=${MINECRAFT}/bin/minecraft.jar}
#MINECRAFT_JAR=/some/other/path/bin/minecraft.jar
echo ${MINECRAFT_JAR}
### Modfile Dir -- The directory where we can find
###                the downloadever ZIPS for the mods(s)
###                I will look in the *CURRENT* dir if
###                you do not specify anything. So it's
###                important to either export MODFILES
###                to your storage area for the .zips,
###                or to copy the zips *yourself* to
###                to the same directotory your'se in
###                *launching* this script from.
###  (( TL;DR? ))
###    Don't edit this file, mods and this file to the
###    same place, run this scrip, hope, and  the magic works.
###
: ${MODFILES:=$PWD}
#MODFILES="${HOME}/Downloads"

### SaveJars Dir -- Keep a copy of al minecraft.jar versions here
###                 They are all tagged with the mod names that
###                 made it in, so you can easily restart at any
###                 point for testing.
###
: ${SAVEJARS:=$PWD}
#SAVEJARS="${HOME}/games/minecraft/mod_backups

### md5sum Utility - This is present on most systems, and should be
###                  found automatically, but if not, enter the
###                  full path here to to the program. While we can
###                  *techcically* proceed without it, you would be
###                  most reliable method of verifying that the mod
###                  files you are using are _correct_ and undamaged.
: ${MD5SUM:=$(which md5sum)}
#MD5SUM=/opt/fancywidgits/with/strange_location/bin/md5sum


###############
# MOD OPTIONS #
###############

# as measured myself, and matches the last line
# in the bin/md5s that came with 1.0.0
MC_JAR_VERSION="1.0.0"
MC_JAR_MD5=3820d222b95d0b8c520d9596a756a6e6
MC_JAR_SIZE=2362837
MC_JAR_FILECOUNT=1127
# filecount *excludes* the META-INF folder which has
# likely already been removed?
#
# other ways to verify the version?


# the mod MD5s for the versions known to work
# along with a the other necessary metadata about
# the mod.
MOD_0_NAME="ModLoader"
MOD_0_URL="http://www.minecraftforum.net/topic/75440-v11-risugamis-mods-everything-updated/"
MOD_0_MD5="2515532b80cee9890be2c7f89c7d8992"
MOD_0_FILE="ModLoader 1.0.0.zip"
MOD_0_SIZE=88347

MOD_1_NAME="ModLoaderMP"
MOD_1_URL="http://www.minecraftforum.net/topic/182918-100smp-flans-mods-planes-ww2-guns-vehicles-playerapi-moods-mputils-teams/#MLM"
MOD_1_MD5="b59a3bae02a2b00a8dadd010e2e5e898"
MOD_1_FILE="ModLoaderMp 1.0.0.zip"
MOD_1_SIZE=24636

MOD_2_NAME="AudioMod"
MOD_2_URL="http://www.minecraftforum.net/topic/75440-v11-risugamis-mods-everything-updated/"
MOD_2_MD5="5cbc7931a6b23876054bfe5cb7eaa993"
MOD_2_FILE="AudioMod 1.0.0.zip"
MOD_2_SIZE=46901

MOD_3_NAME="PlayerAPI"
MOD_3_URL="http://www.minecraftforum.net/topic/738498-100api-player-api/"
MOD_3_MD5="37644b273328ec98440efd685f066671"
MOD_3_FILE="MC 1.0.0 - Player API client 1.6.zip"
MOD_3_SIZE=73898

MOD_4_NAME="ShockAhPI"
MOD_4_URL="http://adf.ly/373209/sapi-r11"
MOD_4_MD5="fb6817b3161da1df2f11165ac31a6ccf"
MOD_4_FILE="SAPI r11.zip"
MOD_4_SIZE=113976
MOD_4_JARFILES="bin"

MOD_5_NAME="Aether"
MOD_5_URL="http://www.minecraftforum.net/topic/893629-100-aether-v104-01-launch-bug-fixed-bug-fixes-crystal-trees-enchanted-grass-white-apples/"
MOD_5_MD5="3166e5e1ac762126129964bc5f791503"
MOD_5_FILE="Aether_1.04_1_Final.zip"
MOD_5_SIZE="28575877"
MOD_5_JARFILES="Aether_1.04_1_Final/Jar"


# <rant>Ahhhh please, no *SPACES* in filenames! It makes a HUGE
# chore to constantly have to wrap everything in "quote sections"
# like you see throughout this file... dash (-) or underscore (_)
# make perfectly good replacements!</rant>

######################################
# END OF MOD-SPECIFIC  CONFIGURATION #m
######################################

count_mods() {
    local c=0
    while true ; do
        local mod_name="MOD_${c}_NAME"
        [[ -n "${!mod_name}" ]] || return $c
        ((c++))
    done
}
count_mods
MOD_COUNT="$?"
echo "*** FOUND ${MOD_COUNT} LISTED MODS"
echo
(( MOD_COUNT > 0 )) || die "Nothing to do!"

MCJAR_DIR=$(dirname "${MINECRAFT_JAR}")
MCJAR_BASE=$(basename "${MINECRAFT_JAR}")
MCJAR_BASE_NOEXT="${MCJAR_BASE%.*}"


echo "*** SETTINGS:"

echo "    Using MineCraft in: ${MINECRAFT}"
echo "     .jar to be modded: ${MINECRAFT_JAR}"
echo "    Search for MODs in: ${MODFILES}"
echo "       saving .jars in: ${SAVEJARS}"
echo "    md5sumn: ${MD5SUM}"
echo
echo "*** CHECKING ENVIRONMENT:"

die() {
    echo
    echo "*** FATAL ERROR!"
    echo "*** Mod install aborted"
    if (($# > 0)) ; then
        echo "*** $@"
    fi
    exit -1
}

# validate basic - yet highly prone to error - setting
[[ -d "${MINECRAFT}"     ]] || die "Minecaft not found at: ${MINECRAFT}"
[[ -w "${MINECRAFT}"     ]] || dir "Minecaft in directory found, but we cannot write to it."
[[ -e "${MINECRAFT_JAR}" ]] || die "Could not find minecraft.jar at ${MINECRAFT_JAR}"
[[ -w "${MINECRAFT_JAR}" ]] || die "Cannot write to ${MINECRAFT_JAR}"
[[ -e "${MODFILES}"      ]] || die "Cannot read ${MODFILES} for mod files, as it does not exist!"
[[ -d "${MODFILES}"      ]] || die "Expected a DIRECTORY to search at: ${MODFILES}"
[[ -d "${SAVEJARS}"      ]] || die "Jar backup area doesn't exist: ${SAVEJARS}"
[[ -d "${SAVEJARS}"      ]] || die "Can only backup jars to a directory."

echo "    Congradulations, the enviornment looks sane and usable!"
echo
echo "*** CHECKING REQUIREMENTS:"

# EMPTY now, but used to access the mod_N_foo variables later
mod_name=
mod_url=
mod_md5=
mod_file=
mod_size=

check_size() {
    local size="$1" path="$2"
    if [[ -n "${!mod_size}" ]] ; then
        declare -r -i testsize="$(stat --format="%s" "$path")"
        if (( size == testsize )) ; then
            echo "       PASS: FileSize (${!mod_size} bytes)"
            return 0
        else
            echo "       FAIL: Filesize - !!! INCORRECT FILE SIZE !!!"
            echo "           CORRECT SIZE: $size bytes"
            echo "            ACTUAL SIZE: $testsize bytes"
            return 1
        fi
    else
        echo "       SKIP: FileSize - missing reverence value"
        return 0
    fi
}


if [[ -n "$MD5SUM" ]] ; then
    check_md5() {
        local md5="$1" path="$2"
        if [[ -z "${md5}" ]] ; then
            echo "       SKIP: MD5check - no reference value"
            return 0
        else
            local testmd5="$(${MD5SUM} "${path}")"
            md5="${md5:0:32}"
            testmd5="${testmd5:0:32}"
            if [[ "$md5" == "$test_md5" ]] ; then
                echo "       FAIL: MD5check - !!! CHECKSUM FAILURE !!!"
                echo "             Incorrect or damaged file?"
                echo "          FAILED FILE: ${path}"
                echo "         EXCPETED MD5: ${md5}"
                echo "           ACTUAL MD5: ${testmd5}"
                return 1
            else
                echo "       PASS: MD5check (${md5})"
                return 0
            fi
        fi
    }
else
    check_md5() {
        "  --> ********  WARNING  ******** <--"
        "  --> Cannot find utility: md5sum <--"
        "  --> SKIPPPING integriety check! <--"
        "  --> ********  WARNING  ******** <--"
    }
fi


# Check the mods a re sanely listed and that
# we have the required files
check_mod_ready() {
    local path="$1" size="$2" hash="$3#3"

    [[ -e "$path" ]] || die "File is Missing. Is it downloaded and in our search?"
    [[ -r "$path" ]] || die "Exists, but could not be read. (permissions?)"

    if ! check_size "${!mod_size}" "$path" ; then return 1; fi
    if ! check_md5  "${!mod_md5}"  "$path" ; then return 1; fi

    return 0
}

verify_initial_jar() {
    local path="$1"

    if ! check_size "${MC_JAR_SIZE}" "$path" ; then return 1; fi
    if ! check_md5  "${MC_JAR_MD5}"  "$path" ; then return 1; fi

    return 0
}

for i in 0 1 2 3 4 5; do
    mod_name="MOD_${i}_NAME"
    mod_md5="MOD_${i}_MD5"
    mod_url="MOD_${i}_URL"
    mod_file="MOD_${i}_FILE"
    mod_size="MOD_${i}_SIZE"

    # FIXME - should auto-sense the number of mods with a while loop
    echo
    echo "   >> VERIFYING: ${PWD}/${!mod_file}"
    if check_mod_ready "${PWD}/${!mod_file}" "${!mod_size}" "${!mod_md5}" ; then
        echo "   >> ${!mod_name} Verified Successfully!"
    else
        die "Could not verify: ${!mod_name}"
    fi
done

echo "   >> VERIFYING: ${MINECRAFT_JAR}"
if verify_initial_jar "${MINECRAFT_JAR}" ; then
    echo "   >> minecraft.jar version ${MC_JAR_VERSION} is clean and ready for modding!"
else
    die "Problem with minecraft.jar!"
fi

echo
echo "    All required files are accounted for and verified!"
echo
echo "*** APPLYING THE MODS:"


chain="${MC_JAR_VERSION}"
declare -a jarmods

apply_mod() {
    local jar="$1" modfile="$2" jarfiles="$3"
    echo "   - Applying: ${modfile}"

    if [[ -n "${jar}" ]] ; then
        jarfiles="${jarfiles}/"
    fi

    # do our work in a temporary folder
    TMPDIR="$(mktemp --directory modtmp-minecraft.jar-XXXXXX)"
    cleanup() {
        popd > /dev/null
        rm -rf "${TMPDIR}"
    }
    # and trap RETURN so we automagically clean up
    # after ourself. Leaving temp files around is messy.
    trap cleanup RETURN
    pushd "${TMPDIR}" > /dev/null

    mkdir -p jar mod

    cd ./mod/
    unzip "$modfile" > /dev/null
    cd ..

    cd ./jar/
    jar xf "${MINECRAFT_JAR}"
    rm -f META-INF/MOJANG_C.*
    cp -r "../mod/${jarfiles}"* .
    jar cf "${MINECRAFT_JAR}" *
    cd ..

    return 0
}

for i in 0 1 2 3 4 5; do
    mod_name="MOD_${i}_NAME"
    mod_md5="MOD_${i}_MD5"
    mod_url="MOD_${i}_URL"
    mod_file="MOD_${i}_FILE"
    mod_size="MOD_${i}_SIZE"
    mod_jarfiles="MOD_${i}_JARFILES"

    apply_mod "${MINECRAFT_JAR}" "${MODFILES}/${!mod_file}" "${!mod_jarfiles}"
    chain="$chain-${!mod_name}"
    backup="${MCJAR_BASE_NOEXT}-${chain}.jar"
    #echo "Backup up intermediate jarfile as:"
    #echo "  >> $backup"
    jarmods[$i]="$backup"
    cp "${MINECRAFT_JAR}" "${SAVEJARS}/${backup}"
done

echo
echo "*** SUCCESS!"
echo
echo "There should be ${MOD_COUNT} mods installed now, ready"
echo "for however you usually launch minecraft."
if [[ -n "${SAVEJARS}" ]] && (( MOD_COUNT > 1 )) ; then
    echo
    echo "Remember: there are intermediate backups available!"
    echo "If there is a problem starting minecraft even with"
    echo "this script, it may be necessary to go on a more extensive"
    echo "bug hunting investigation. A good place to start, though,"
    echo "woudl probably be by testing these jars. That way, you"
    echo "should be able to narrow it down to *which* mod is the"
    echo "one breaking your Minecraft."
    jarcount=${MOD_COUNT}
    echo
    echo "    >>> CURENTLY minecraft.jar (backup .jar)"
    ((jarcount--))
    echo "        ${jarmods[jarcount]}"
    echo
    echo "    >>> AVAILABLE jars with fewer mods"
    while (( jarcount > 0 )) ; do
        ((jarcount--))
        echo "        ${jarmods[$jarcount]}"
    done
fi
echo


echo "*** END OF SCRIPT"
exit 0
