SHELL=/bin/sh

.PHONY: install

install:
	@/opt/local/bin/blackbox_decrypt_all_files
	/usr/bin/install -C -m 600 -o root -g wheel auto_shares /etc
	@if ! /usr/bin/grep -q auto_shares /etc/auto_master; then /bin/cat auto_shares >> /etc/auto_master; fi
	@echo "Check that auto_master.append has been appended to /etc/auto_master."
