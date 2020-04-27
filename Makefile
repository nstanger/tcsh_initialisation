SHELL=/bin/sh

.PHONY: install init user shared gui bin dotfiles

FIND=/usr/bin/find
INSTALL=/usr/bin/install
LAUNCHCTL=/bin/launchctl
SUDO=/usr/bin/sudo

EFFECTIVE_USER=$(shell /usr/bin/logname)
EFFECTIVE_GROUP=$(shell /usr/bin/id -gn $(EFFECTIVE_USER))

INITDIR=/usr/local/share/tcsh/examples
USERHOME=/Users/$(EFFECTIVE_USER)
USERINITDIR=$(USERHOME)/Library/init/tcsh
USERBINDIR=/Users/$(EFFECTIVE_USER)/bin
SHAREDHOME=/Users/Shared
SHAREDINITDIR=$(SHAREDHOME)/init/tcsh
SHAREDBINDIR=$(SHAREDHOME)/bin

INITFILES=$(patsubst %.gpg,%,$(wildcard init/*))
USERFILES=$(patsubst %.gpg,%,$(wildcard user/*))
SHAREDFILES=$(patsubst %.gpg,%,$(wildcard shared/*))
USERBINFILES=bin/url_encode_cwd gui/gui_environment bin/vpn
SHAREDBINFILES=bin/bb bin/preview bin/restart-postgresql-server bin/vscd
DOTFILES=.login .logout .bashrc $(patsubst %.gpg,%,$(shell $(FIND) git -type f)) \
	$(shell $(FIND) logrotate -type f)
PATHFILES=$(wildcard gui/paths.d/*)
VIRTUALENVS=$(shell $(FIND) .virtualenvs -name "*.txt")
SUDOERS=$(wildcard sudoers.d/*)

install: init user shared gui bin dotfiles sudoers

init: 
	$(INSTALL) -d $(INITDIR)
	$(INSTALL) -cbS -m 0644 $(INITFILES) $(INITDIR)

user:
	$(INSTALL) -d -o $(EFFECTIVE_USER) -g $(EFFECTIVE_GROUP) $(USERINITDIR)
	$(INSTALL) -cbS -m 0644 -o $(EFFECTIVE_USER) -g $(EFFECTIVE_GROUP) $(USERFILES) $(USERINITDIR)

shared: shared/environment.shared
	$(INSTALL) -d -o $(EFFECTIVE_USER) -g $(EFFECTIVE_GROUP) $(SHAREDINITDIR)
	$(INSTALL) -cbS -m 0644 -o $(EFFECTIVE_USER) -g $(EFFECTIVE_GROUP) $(SHAREDFILES) $(SHAREDINITDIR)
	@echo "Don't forget to uncomment the HANDBOOK_INSTALL_ROOT and PRINTER variables."

bin:
	$(INSTALL) -d -o $(EFFECTIVE_USER) -g $(EFFECTIVE_GROUP) $(USERBINDIR)
	$(INSTALL) -d -o $(EFFECTIVE_USER) -g $(EFFECTIVE_GROUP) $(USERBINDIR)
	$(INSTALL) -cbS -m 0755 -o $(EFFECTIVE_USER) -g $(EFFECTIVE_GROUP) $(USERBINFILES) $(USERBINDIR)
	$(INSTALL) -cbS -m 0755 -o $(EFFECTIVE_USER) -g $(EFFECTIVE_GROUP) $(SHAREDBINFILES) $(SHAREDBINDIR)

# What here needs sudo and what doesn't?
gui: gui/environment $(PATHFILES)
	$(SUDO) $(INSTALL) -c -m 0644 $(PATHFILES) /etc/paths.d
	-$(LAUNCHCTL) unload -w /Library/LaunchAgents/environment.user.plist
	-$(LAUNCHCTL) unload -w /Library/LaunchDaemons/environment.plist
	$(SUDO) $(INSTALL) -cbS -m 0555 gui/environment /etc
	$(INSTALL) -c -m 0644 gui/environment.plist /Library/LaunchDaemons
	$(INSTALL) -c -m 0644 gui/environment.user.plist /Library/LaunchAgents
	$(SUDO) -u $(EFFECTIVE_USER) $(LAUNCHCTL) load -w /Library/LaunchAgents/environment.user.plist
	$(LAUNCHCTL) load -w /Library/LaunchDaemons/environment.plist

dotfiles: $(DOTFILES)
	$(INSTALL) -cbS -m 0644 -o $(EFFECTIVE_USER) -g $(EFFECTIVE_GROUP) $(DOTFILES) $(USERHOME)
	$(INSTALL) -d -m 0755  -o $(EFFECTIVE_USER) -g $(EFFECTIVE_GROUP) $(USERHOME)/.virtualenvs
	$(INSTALL) -cbS -m 0644  -o $(EFFECTIVE_USER) -g $(EFFECTIVE_GROUP) $(VIRTUALENVS) $(USERHOME)/.virtualenvs

sudoers: $(SUDOERS)
	$(SUDO) $(INSTALL) -cS -m 0440 $< /etc/sudoers.d

%: %.gpg
	/opt/local/bin/blackbox_decrypt_all_files

clean:
	/bin/cat .gitignore | /usr/bin/xargs /bin/rm -f

debug:
	@echo "EFFECTIVE_USER = ${EFFECTIVE_USER}"
	@echo "EFFECTIVE_GROUP = ${EFFECTIVE_GROUP}"
	@echo "INITDIR = ${INITDIR}"
	@echo "USERINITDIR = ${USERINITDIR}"
	@echo "SHAREDHOME = ${SHAREDHOME}"
	@echo "USERBINDIR = ${USERBINDIR}"
	@echo "INITFILES = ${INITFILES}"
	@echo "USERFILES = ${USERFILES}"
	@echo "SHAREDFILES = ${SHAREDFILES}"
	@echo "USERBINFILES = ${USERBINFILES}"
	@echo "DOTFILES = ${DOTFILES}"
	@echo "VIRTUALENVS = ${VIRTUALENVS}"
