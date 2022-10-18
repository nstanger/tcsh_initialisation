#####################################################################
# Completions.

# Automatic rehash
zstyle ':completion:*' rehash true

# Initially generated by compinstall, but hand-modified since.
# Combines ideas from <https://unix.stackexchange.com/a/97349>
# and <https://stackoverflow.com/a/24237590>.
zstyle ':completion:*' completer _complete _ignored _approximate
# zstyle ':completion:*' matcher-list 'm:{[:lower:]}={[:upper:]}' 'r:|[._-]=* r:|=*'
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]-_}={[:upper:][:lower:]_-}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

autoload -Uz compinit
# Only check once per day whether the cached .zcompdump file needs to be
# regenerated (see <https://gist.github.com/ctechols/ca1035271ad134841284>).
function {
    setopt extended_glob local_options
    if [[ ! -e ${HOME}/.zcompdump || -n ${HOME}/.zcompdump(#qNY1.mh+24) ]]; then
        compinit
        touch .zcompdump
    else
        compinit -C
    fi
}


#####################################################################
# Path. We can't just put files in /etc/paths.d because they are added
# at the end not at the front.
# Take advantage of the fact that $PATH (string) and $path (array) are
# automatically kept in sync.
# This is here rather than in .zshenv because Apple stupidly initialises
# the path in /etc/zprofile, which is sourced *after* .zshenv >:(.
# Ensure path has no duplicate entries.
typeset -U path
homebrew_paths=($(cat ${HOME}/.homebrew_paths | sed -e "s|@BREW_PREFIX@|${BREW_PREFIX}|g"))
path=($homebrew_paths[@] $path[@] ${HOME}/bin /Users/Shared/bin)

# Homebrew automatically installs the following in /etc/paths.d:
# /Library/TeX/texbin
# /opt/X11/bin


#####################################################################
# Useful configuration from <https://scriptingosx.com/2019/06/moving-to-zsh/>.

# Case-insensitive globbing
setopt NO_CASE_GLOB

# Directory changing
# directory search path (auto-complete directories, cf. tcsh)
cdpath=($HOME $HOME/Documents $HOME/Documents/Development $HOME/Documents/Teaching)
# add "cd" to bare directory names
setopt AUTO_CD
# push the previous directory onto the stack
setopt AUTO_PUSHD
# maximum directory stack size
DIRSTACKSIZE=10
# ignore duplicates in the directory stack
setopt PUSHD_IGNORE_DUPS
# swap meaning of cd +/- so that -2 means item numbered 2 in the stack,
# not the second from the bottom
setopt PUSHD_MINUS

# Shell history
# extended history information
setopt EXTENDED_HISTORY
# share history across multiple zsh sessions (implies INC_APPEND_HISTORY)
setopt SHARE_HISTORY
# append to history
setopt APPEND_HISTORY
# expire duplicates first
setopt HIST_EXPIRE_DUPS_FIRST 
# do not store any duplications
setopt HIST_IGNORE_ALL_DUPS
# ignore duplicates when searching
setopt HIST_FIND_NO_DUPS
# don't save duplicates to the history file
setopt HIST_SAVE_NO_DUPS
# removes extra blanks from commmands in history
setopt HIST_REDUCE_BLANKS
# verify !! command substitution
setopt HIST_VERIFY

# Auto-correction
setopt CORRECT
# setopt CORRECT_ALL

# Search instead of just up and down arrow (cf. ^R)
bindkey "^[[A" up-line-or-search # up arrow bindkey
bindkey "^[[B" down-line-or-search # down arrow

# Input/output
# Allow comments in interactive shells
setopt INTERACTIVE_COMMENTS

# Miscellaneous
# Force prompts to be re-evaluated <https://unix.stackexchange.com/a/40646>.
setopt PROMPT_SUBST


#####################################################################
# Python virtualenv wrapper. This appears to conflict with the "ls"
# aliases below, so it has to happen first.
#source virtualenvwrapper.sh
# workaround to hide "egrep: warning: egrep is obsolescent; using ggrep -E"
# (warning in GNU egrep wrapper at /usr/local/opt/grep/bin/gegrep)
source virtualenvwrapper.sh > /dev/null 2>&1


#####################################################################
# Key bindings.

# backspace should be bound by default, being careful
bindkey "^H" backward-delete-char
# forward delete
bindkey "\e[3~" delete-char

# option backspace should be bound by default, being careful
bindkey "\e^?" backward-kill-word
# option forward delete
bindkey "\e(" kill-word

# control U should be bound by default, being careful
bindkey "^U" backward-kill-line


#####################################################################
# Environment variables for TEXMF paths. For some reason these don't
# work in .zshenv ("/Library/TeX/texbin/kpsexpand: line 117: kpsewhich:
# command not found"). *shrug*
export TEXMFCONFIG=$(/Library/TeX/texbin/kpsexpand '$TEXMFCONFIG')
export TEXMFDIST=$(/Library/TeX/texbin/kpsexpand '$TEXMFDIST')
export TEXMFHOME=$(/Library/TeX/texbin/kpsexpand '$TEXMFHOME')
export TEXMFLOCAL=$(/Library/TeX/texbin/kpsexpand '$TEXMFLOCAL')
export TEXMFMAIN=$(/Library/TeX/texbin/kpsexpand '$TEXMFMAIN')
export TEXMFSYSCONFIG=$(/Library/TeX/texbin/kpsexpand '$TEXMFSYSCONFIG')
export TEXMFSYSVAR=$(/Library/TeX/texbin/kpsexpand '$TEXMFSYSVAR')
export TEXMFVAR=$(/Library/TeX/texbin/kpsexpand '$TEXMFVAR')


#####################################################################
# Aliases.

# Miscellaneous
alias empty="/bin/rm -rf ~/.Trash/*"
alias unlocktrash="/usr/bin/sudo /usr/sbin/chown -R ${USER}:${GROUP} ~/.Trash/*"
# Note: requires Homebrew installed gls
# Alias expansion causes issues with things like brew ls or git ls;
# the only solution so far is to quote the ls e.g., git \ls or git "ls".
# Might a function fix this?
alias ls="${BREW_PREFIX}/bin/gls --classify --color=auto"
alias l="${BREW_PREFIX}/bin/gls --classify --color=auto -l"
alias ll="${BREW_PREFIX}/bin/gls --classify --color=auto -la"
alias l@="/bin/ls -l@"
alias ll@="/bin/ls -al@"
alias man="/usr/local/bin/openman"
alias rm="/bin/rm -i"
alias locate="${BREW_PREFIX}/bin/glocate -d /var/db/locate.database"
# alias smbclient="rlwrap /opt/local/bin/smbclient"
alias beep="/usr/bin/tput bel"
alias grep="${BREW_PREFIX}/bin/ggrep --color=auto"

# Set Terminal window and tab title
alias winname='printf "\033]2;%s\a"'
alias tabname='printf "\033]1;%s\a"'

# Various ISPMS and other related scripts
alias load_assessment="${BREW_PREFIX}/bin/php $TEACHING_SHARED/ISPMS/scripts/marking/load_assessment/load_assessment.php"
alias merge="${BREW_PREFIX}/bin/php $TEACHING_SHARED/ISPMS/scripts/marking/results_reporting/merge.php"
alias marking_form="/opt/X11/bin/xrdb < ~/.Xdefaults; tclsh $TEACHING_SHARED/ISPMS/scripts/marking/marking-form.tcl"
alias process_podcast="/usr/bin/python $TEACHING_SHARED/Tools/process_podcast/process_podcast.py"
alias process_submissions="/usr/bin/python $TEACHING_SHARED/ISPMS/scripts/marking/load_assessment/process_submissions.py"

# Python
# Python 2 and the "python" executable disappear in more recent macOS, but some
# things still look for "python", e.g., zsh-git-prompt.
if [[ -z $(command -v python) ]]
then
    alias python="python3"
fi

# Java
alias rstudio="/bin/sh -c 'unset JAVA_HOME; R CMD open -a /Applications/RStudio.app'"
# Homebrew plantuml already does headless
# alias plantuml="/usr/bin/java -Djava.awt.headless=true -jar ${BREW_PREFIX}/bin/plantuml.jar"

# Others
eval $(${BREW_PREFIX}/bin/thefuck --alias)
alias saxon-b="/usr/bin/java -jar ${BREW_PREFIX}/share/saxon-b/saxon9.jar"


#####################################################################
# Shell prompt.
# <https://scriptingosx.com/2019/07/moving-to-zsh-06-customizing-the-zsh-prompt/>
# Also see comments of <https://unix.stackexchange.com/a/582702> regarding
# how to change the default prompt character.
if [[ -v SSH_CLIENT ]]
then
    # f058 = nf-fa-check_circle
    # f057 = nf-fa-times_circle
    PROMPT=$'%B%(?.%F{green}\uf058%f.%F{red}\uf057 %?%f) %F{202}$(vpn-status)%f%F{magenta}%m:%6(~.%-2~/…/%3~.%~)%(!:#:>)%f%b '
else
    PROMPT=$'%B%(?.%F{green}\uf058%f.%F{red}\uf057 %?%f) %F{202}$(vpn-status)%f%F{magenta}%6(~.%-2~/…/%3~.%~)%(!:#:>)%f%b '
fi
# Git status right prompt.
RPROMPT='$(git status --porcelain=v2 --branch --show-stash -z 2>/dev/null | zsh-rust-git-prompt)'


#####################################################################
# Lazy-load the Python virtualenv wrapper so that it doesn't slow down
# shell initialisation. "workon" is an obvious hook as it's the most
# likely thing to want to do first (could alias other function as well,
# I guess, but this will do for now).
function workon() {
    # source virtualenvwrapper.sh && workon
    # workaround to hide "egrep: warning: egrep is obsolescent; using ggrep -E"
    # (warning in GNU egrep wrapper at /usr/local/opt/grep/bin/gegrep)
    source virtualenvwrapper.sh > /dev/null 2>&1 && workon
}


#####################################################################
# Set up Perl to use "local::lib".
eval "$(perl -I${HOME}/Library/perl5/lib/perl5 -Mlocal::lib=${HOME}/Library/perl5)"


#####################################################################
# Initialise homebrew-command-not-found
# Dammit, the path is not quite the same on x86_64 vs arm64 :(.
if [[ "$(uname -m)" = "arm64" ]]; then
    HB_CNF_HANDLER="$(brew --prefix)/Library/Taps/homebrew/homebrew-command-not-found/handler.sh"
else
    HB_CNF_HANDLER="$(brew --prefix)/Homebrew/Library/Taps/homebrew/homebrew-command-not-found/handler.sh"
fi
if [[ -f "$HB_CNF_HANDLER" ]]; then
    source "$HB_CNF_HANDLER";
fi


#####################################################################
# Source any local scripts in ~/.zshrc.d
function () {
    # null_glob prevents an error if the directory is empty
    # (see <https://unix.stackexchange.com/a/504718>)
    setopt null_glob local_options
    if [[ -d "$HOME/.zshrc.d" ]]; then
        for FILE in $HOME/.zshrc.d/*; do
            source "$FILE"
        done
        unsetopt null_glob
    fi
}


#####################################################################
# Shell add-ons.

# automatic completion suggestions
source ${BREW_PREFIX}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
# use a slightly lighter shade of grey
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=246"

# vi mode
# source ${BREW_PREFIX}/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh

# suggest existing aliases
source ${BREW_PREFIX}/share/zsh-you-should-use/you-should-use.plugin.zsh

# syntax highlighting - MUST be loaded last!
source ${BREW_PREFIX}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
