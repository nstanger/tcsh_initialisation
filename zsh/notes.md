# zsh notes

## Initialisation files

On macOS, zsh reads the following files in this order (<https://zsh.sourceforge.io/Intro/intro_3.html>):

* `/etc/zshenv` [global], `~/.zshenv` [user]: Sets up environment for all shell invocations (interactive or otherwise). According to the documentation it should “contain commands to set the command search path **[but see `zprofile` below]**, plus other important environment variables”. Note that macOS doesn’t supply `/etc/zshenv` by default, and OS updates may stomp on any custom version.
* `/etc/zprofile` [global], `~/.zprofile` [user]: An alternative/addition to `zlogin` (below) that “should contain commands that should be executed only in login shells”. The documentation specifically says that this is “not the place for alias definitions, options, environment variable settings, etc.; as a general rule, it should not change the shell environment at all”. **However, the macOS-supplied `/etc/zprofile` uses `path_helper` to set `PATH`!!** This interferes with any path configuration done in the `zshenv` files (the proper location). 😖🤬 OS updates will most likely stomp on any customisations to `/etc/zprofile`.
* `/etc/zshrc` [global], `/etc/zshrc_Apple_Terminal` [global], `~/.zshrc` [user]: These are “sourced in interactive shells” and “should contain commands to set up aliases, functions, options, key bindings, etc.” In particular:
  * The macOS-supplied `/etc/zshrc` sets up some basic key mappings and support for Apple’s Terminal.app (also see `/etc/zshrc_Apple_Terminal`).
  * The macOS-supplied `/etc/zshrc_Apple_Terminal` sets up shell resumption and working directory support for Terminal.app (so you don’t need to do it yourself!). Note the implied ability to add support for other terminal apps.
* `/etc/zlogin` [global], `~/.zlogin` [user]: As per `zprofile` above. (Technically these are the better ones to use in general.) `/etc/zlogin` isn’t supplied by macOS.
* `~/.zlogout` [user], `/etc/zlogout` [global]: These are sourced when the shell exits. `/etc/zlogout` isn’t supplied by macOS.

## Configuring the path

Putting paths into `/etc/paths` is probably a bad idea, as OS updates will probably stomp on them. Paths added to `/etc/paths.d`, appear to be safe, so this is a good way to add paths where order is unimportant.

For paths where order *is* important (e.g., masking existing executables with ones installed by Homebrew) you can easily prepend them to the path by taking advantage of the `path` array (`PATH` and `path` are automatically synchronised in zsh). Save the paths in a file (one per line), read the file into an array variable, then concatenate that with the existing `path`. For example:

```sh
homebrew_paths=($(cat ${HOME}/.homebrew_paths))
path=($homebrew_paths[@] $path[@])
```

**This must be done in `~/.zshrc`** because of the  `/etc/zprofile` stupidity noted above.
