SHELL=/bin/sh

.PHONY: install init user shared gui bin dotfiles

INSTALL=/usr/bin/install
LAUNCHCTL=/bin/launchctl

EFFECTIVE_USER=$(shell logname)
EFFECTIVE_GROUP=$(shell id -gn $(EFFECTIVE_USER))

INITDIR=/usr/local/share/tcsh/examples
USERDIR=/Users/$(EFFECTIVE_USER)/Library/init/tcsh
USERHOME=/Users/$(EFFECTIVE_USER)
SHAREDDIR=/Users/Shared/init/tcsh
BINDIR=/Users/$(EFFECTIVE_USER)/bin

INITFILES=$(wildcard init/*)
USERFILES=$(wildcard user/*)
SHAREDFILES=$(wildcard shared/*)
BINFILES=$(wildcard bin/*)
DOTFILES=.login #.tcshrc

install: init user shared gui bin dotfiles

init:
	$(INSTALL) -d $(INITDIR)
	$(INSTALL) -cbS -m 0644 $(INITFILES) $(INITDIR)

user:
	$(INSTALL) -d -o $(EFFECTIVE_USER) -g $(EFFECTIVE_GROUP) $(USERDIR)
	$(INSTALL) -cbS -m 0644 -o $(EFFECTIVE_USER) -g $(EFFECTIVE_GROUP) $(USERFILES) $(USERDIR)

shared:
	$(INSTALL) -d -o $(EFFECTIVE_USER) -g $(EFFECTIVE_GROUP) $(SHAREDDIR)
	$(INSTALL) -cbS -m 0644 -o $(EFFECTIVE_USER) -g $(EFFECTIVE_GROUP) $(SHAREDFILES) $(SHAREDDIR)

bin:
	$(INSTALL) -d -o $(EFFECTIVE_USER) -g $(EFFECTIVE_GROUP) $(BINDIR)
	$(INSTALL) -cbS -m 0755 -o $(EFFECTIVE_USER) -g $(EFFECTIVE_GROUP) $(BINFILES) $(BINDIR)

gui:
	-$(LAUNCHCTL) unload -w /Library/LaunchAgents/environment.user.plist
	-$(LAUNCHCTL) unload -w /Library/LaunchDaemons/environment.plist
	$(INSTALL) -cbS -m 0555 gui/environment /etc
	$(INSTALL) -c -m 0644 gui/environment.plist /Library/LaunchDaemons
	$(INSTALL) -c -m 0644 gui/environment.user.plist /Library/LaunchAgents
	sudo -u $(EFFECTIVE_USER) $(LAUNCHCTL) load -w /Library/LaunchAgents/environment.user.plist
	$(LAUNCHCTL) load -w /Library/LaunchDaemons/environment.plist

dotfiles:
	$(INSTALL) -cbS -m 0644 -o $(EFFECTIVE_USER) -g $(EFFECTIVE_GROUP) $(DOTFILES) $(USERHOME)

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
