SHELL=/bin/sh

.PHONY: install

install: auto_shares
	/usr/bin/install -C -m 400 -o root -g wheel auto_shares /etc
	@if ! /usr/bin/grep -q auto_shares /etc/auto_master; then /bin/cat auto_master.append >> /etc/auto_master; fi
	@echo "Check that auto_master.append has been appended to /etc/auto_master."
	@echo "Use  sudo automount -vc  to reload the mounts."

auto_shares: auto_shares.gpg
	@/usr/local/bin/blackbox_decrypt_all_files
	@chown nstanger auto_shares
	@chmod 600 auto_shares

clean:
	@git clean -fX
