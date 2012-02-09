# software we use during building
MOVE=mv --force
COPY=cp --no-clobber
RMTREE=rm -rf
CC_DIRCOLORS=dircolors -b

# shorthand for bashEV[ROOT]
EVDIR = $(CURDIR)
# shorthand for the often-use folders
LIB := $(EVDIR)/lib
ETC := $(EVDIR)/etc
CACHEDIR := $(EVDIR)/var/cache

sysOFF := $(ETC)/system_bashrc-BYPASS
sysON  := $(ETC)/system_bashrc-ENABLED
sysTPL := $(ETC)/templates/internal/system_bashrc_flag


caches  :=
targets := $(LIB)/env/LS_COLORS.bash


# by default, just build everything (which is expected,
# behavior from make).
#
# sur[rising maker feverythikgns noramlly expected from MAKE. This probably
# ignoreos that
all: build
.PHONY: all

.SUFFIXES:

#########################################################
##   Enabling/Disabling of the System's global bashrc  ##
#########################################################

$(sysOFF):
	$(MOVE) "$(sysON)" "$(sysOFF)" || $(COPY) "$(sysTPL)" "$(sysOFF)"
	@echo "*** loading of system rcfiles: DISABLED ***"

$(sysON):
	$(MOVE) "$(sysOFF)" "$(sysON)" || $(COPY) "$(sysTPL)" "$(sysON)"
	@echo "*** loading of system rcfiles: ENABLED ***"

.PHONY: sysrc_on sysrc_off
sysrc_off: "$(sysOFF)"
sysrc_on:  "$(sysON)"


#########################################################
##  Cleaning up after ourselves and our build/install  ##
#########################################################

.PHONY: clean distclean clean-targets clean-cache clean-temp

clean-targets:
	$(RMTREE) $(targets)

clean-cache:
	$(RMTREE) $(CACHEDIR)/cache-*

clean-temp:
	$(RMTREE) *~

clean: clean-temp clean-cache
distclean: clean clean-targets


##################################################################
##   BUILD - Generate needed items, cache some thigns in bash   ##
##################################################################

.PHONY: build build-cache build-targets

build-caches: $(caches)


build-targets: $(targets)

build: build-caches build-targets



###          ----------------------------
###       >> Build Details & Dependencies <<
###          ----------------------------


$(LIB)/env/LS_COLORS.bash: $(ETC)/LS_COLORS.dircolors
	rm -f $@
	$(CC_DIRCOLORS) $< > $@



# EOF
