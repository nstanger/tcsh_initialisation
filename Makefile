SHELL=/bin/sh

.PHONY: install init user shared gui

INSTALL=/usr/bin/install
LAUNCHCTL=/bin/launchctl

INITDIR=/usr/local/share/tcsh/examples
USERDIR=$(HOME)/Library/init/tcsh
SHAREDDIR=/Users/Shared/init/tcsh
BINDIR=$(HOME)/bin

INITFILES=$(wildcard init/*)
USERFILES=$(wildcard user/*)
SHAREDFILES=$(wildcard shared/*)
BINFILES=$(wildcard bin/*)

install: init user shared gui bin

init:
	$(INSTALL) -d $(INITDIR)
	$(INSTALL) -c -b -m 0644 $(INITFILES) $(INITDIR)

user:
	$(INSTALL) -d -o $(USER) -g $(GROUPS) $(USERDIR)
	$(INSTALL) -c -b -m 0644 -o $(USER) -g $(GROUPS) $(USERFILES) $(USERDIR)

shared:
	$(INSTALL) -d -o $(USER) -g $(GROUPS) $(SHAREDDIR)
	$(INSTALL) -c -b -m 0644 -o $(USER) -g $(GROUPS) $(SHAREDFILES) $(SHAREDDIR)

bin:
	$(INSTALL) -d -o $(USER) -g $(GROUPS) $(BINDIR)
	$(INSTALL) -c -b -m 0755 $(BINFILES) $(BINDIR)

gui:
	-$(LAUNCHCTL) unload -w /Library/LaunchAgents/environment.user.plist
	-$(LAUNCHCTL) unload -w /Library/LaunchDaemons/environment.plist
	$(INSTALL) -c -b -m 0555 gui/environment /etc
	$(INSTALL) -c -m 0644 gui/environment.plist /Library/LaunchDaemons
	$(INSTALL) -c -m 0644 gui/environment.user.plist /Library/LaunchAgents
	sudo -u $(USER) $(LAUNCHCTL) load -w /Library/LaunchAgents/environment.user.plist
	$(LAUNCHCTL) load -w /Library/LaunchDaemons/environment.plist
