# Set up tcsh environment

Installs the following:

* Wilfredo Sanchez’s tcsh initialisation scripts in /usr/local/share
* shared initialisation scripts in /Users/Shared/init
* user initialisation scripts in $HOME/Library/init
* GUI environment variable configuration in /etc

Any existing files are backed up before being overwritten.

The effective initialisation order is:

```sh
/etc/csh.cshrc
/etc/csh.login
.tcshrc
    environment.mine
    environment.shared
    rc.shared
    rc.mine
    aliases.mine
    aliases.shared
    completions.mine
    completions.shared
.login
    path.mine
    path.shared
    login.mine
    login.shared
```

# Other configurations

Mainly `.` files that should be copied to `~`.
