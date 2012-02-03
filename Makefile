# shorthand for bashEV[ROOT]
EV=~/.bash
# shorthand for the often-use folders
L=$(EV)/lib


caches=$(L)/etc/ls_colors.sh
targets=

all: build
.PHONY: all


#################################################################
###  Cleaning up after ourselves and our build/inall/tec

clean-cache:
.PHONY: clean-cache
	rm -rf $(caches)

clean-gargets:
.PHONY: clean-targets
	rm -rf $(caches)

distclean: clean-temp clean-cache clean-targets
.PHONY: distclean

clean: clean-temp clean-cache
.PHONY: clean


##################################################################
##   BUILD - Generate needed items, cache some thigns in bash   ##
##################################################################

build-caches: $(caches)
.PHONY: build-cache


build-targets: $(targets)
.PHONY: build-targets
	rm -rf $(caches)

build: build-caches build-targets
.PHONY: build




###          ----------------------------
###       >> Build Details & Dependencies <<
###          ----------------------------


lib/etc/ls_colors.sh: etc/DIR_COLORS
	dircolors -b $< > $@




# EOF
