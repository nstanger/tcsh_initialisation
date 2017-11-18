SHELL=/bin/sh

.PHONY: install init user shared gui bin

INSTALL=/usr/bin/install
LAUNCHCTL=/bin/launchctl

EFFECTIVE_USER=$(shell logname)
EFFECTIVE_GROUP=$(shell id -gn $(EFFECTIVE_USER))

INITDIR=/usr/local/share/tcsh/examples
USERDIR=/Users/$(EFFECTIVE_USER)/Library/init/tcsh
SHAREDDIR=/Users/Shared/init/tcsh
BINDIR=/Users/$(EFFECTIVE_USER)/bin

INITFILES=$(wildcard init/*)
USERFILES=$(wildcard user/*)
SHAREDFILES=$(wildcard shared/*)
BINFILES=$(wildcard bin/*)

install: init user shared gui bin

init:
	$(INSTALL) -d $(INITDIR)
	$(INSTALL) -c -b -m 0644 $(INITFILES) $(INITDIR)

user:
	$(INSTALL) -d -o $(EFFECTIVE_USER) -g $(EFFECTIVE_GROUP) $(USERDIR)
	$(INSTALL) -c -b -m 0644 -o $(EFFECTIVE_USER) -g $(EFFECTIVE_GROUP) $(USERFILES) $(USERDIR)

shared:
	$(INSTALL) -d -o $(EFFECTIVE_USER) -g $(EFFECTIVE_GROUP) $(SHAREDDIR)
	$(INSTALL) -c -b -m 0644 -o $(EFFECTIVE_USER) -g $(EFFECTIVE_GROUP) $(SHAREDFILES) $(SHAREDDIR)

bin:
	$(INSTALL) -d -o $(EFFECTIVE_USER) -g $(EFFECTIVE_GROUP) $(BINDIR)
	$(INSTALL) -c -b -m 0755 -o $(EFFECTIVE_USER) -g $(EFFECTIVE_GROUP) $(BINFILES) $(BINDIR)

gui:
	-$(LAUNCHCTL) unload -w /Library/LaunchAgents/environment.user.plist
	-$(LAUNCHCTL) unload -w /Library/LaunchDaemons/environment.plist
	$(INSTALL) -c -b -m 0555 gui/environment /etc
	$(INSTALL) -c -m 0644 gui/environment.plist /Library/LaunchDaemons
	$(INSTALL) -c -m 0644 gui/environment.user.plist /Library/LaunchAgents
	sudo -u $(EFFECTIVE_USER) $(LAUNCHCTL) load -w /Library/LaunchAgents/environment.user.plist
	$(LAUNCHCTL) load -w /Library/LaunchDaemons/environment.plist

debug:
	@echo "EFFECTIVE_USER = ${EFFECTIVE_USER}"
	@echo "EFFECTIVE_GROUP = ${EFFECTIVE_GROUP}"
	@echo "INITDIR = ${INITDIR}"
	@echo "USERDIR = ${USERDIR}"
	@echo "SHAREDDIR = ${SHAREDDIR}"
	@echo "BINDIR = ${BINDIR}"
	@echo "INITFILES = ${INITFILES}"
	@echo "USERFILES = ${USERFILES}"
	@echo "SHAREDFILES = ${SHAREDFILES}"
	@echo "BINFILES = ${BINFILES}"
