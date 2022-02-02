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
compinit


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


#####################################################################
# Python virtualenv wrapper. This appears to conflict with the "ls"
# aliases below, so it has to happen first.
source virtualenvwrapper.sh


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
alias empty="rm -rf ~/.Trash/*"
alias unlocktrash="sudo chown -R ${USER}:${GROUP} ~/.Trash/*"
# Note: requires Homebrew installed gls
# Alias expansion causes issues with things like brew ls or git ls;
# the only solution so far is to quote the ls e.g., git \ls or git "ls".
# Might a function fix this?
alias -g ls="/usr/local/bin/gls --classify --color=auto"
alias -g l="ls -l"
alias -g ll="ls -la"
alias -g l@="/bin/ls -l@"
alias -g ll@="/bin/ls -al@"
alias man="/usr/local/bin/openman"
alias -g rm="rm -i"
alias locate="/usr/local/bin/glocate -d /var/db/locate.database"
# alias smbclient="rlwrap /opt/local/bin/smbclient"
alias -g beep="tput bel"
alias -g grep="/usr/local/bin/ggrep --color=auto"

# Set Terminal window and tab title
alias winname='printf "\033]2;%s\a"'
alias tabname='printf "\033]1;%s\a"'

# Various ISPMS and other related scripts
alias load_assessment-"php $TEACHING_SHARED/ISPMS/scripts/marking/load_assessment/load_assessment.php"
alias merge="php $TEACHING_SHARED/ISPMS/scripts/marking/results_reporting/merge.php"
alias marking_form="xrdb < ~/.Xdefaults; tclsh $TEACHING_SHARED/ISPMS/scripts/marking/marking-form.tcl"
alias process_podcast="python $TEACHING_SHARED/Tools/process_podcast/process_podcast.py"
alias process_submissions="python $TEACHING_SHARED/ISPMS/scripts/marking/load_assessment/process_submissions.py"

# Java
alias rstudio="sh -c 'unset JAVA_HOME; R CMD open -a /Applications/RStudio.app'"
alias java_home="/usr/libexec/java_home"
# Homebrew plantuml already does headless
# alias plantuml="/usr/bin/java -Djava.awt.headless=true -jar /usr/local/bin/plantuml.jar"

# Others
eval $(/usr/local/bin/thefuck --alias)
alias saxon-b="java -jar /usr/local/share/saxon-b/saxon9.jar"


#####################################################################
# Shell resumption <https://superuser.com/a/328148>.
if [[ "$TERM_PROGRAM" == "Apple_Terminal" ]] && [[ -z "$INSIDE_EMACS" ]]; then

    update_terminal_cwd() {
        # Identify the directory using a "file:" scheme URL, including
        # the host name to disambiguate local vs. remote paths.

        # Percent-encode the pathname.
        local url_path=''
        {
            # Use LC_CTYPE=C to process text byte-by-byte. Ensure that
            # LC_ALL isn't set, so it doesn't interfere.
            local i ch hexch LC_CTYPE=C LC_ALL=
            for ((i = 1; i <= ${#PWD}; ++i)); do
                ch="$PWD[i]"
                if [[ "$ch" =~ [/._~A-Za-z0-9-] ]]; then
                    url_path+="$ch"
                else
                    printf -v hexch "%02X" "'$ch"
                    url_path+="%$hexch"
                fi
            done
        }

        printf '\e]7;%s\a' "file://$HOST$url_path"
    }

    # Register the function so it is called at each prompt.
    autoload add-zsh-hook
    add-zsh-hook precmd update_terminal_cwd
fi


#####################################################################
# Shell prompt.
# <https://scriptingosx.com/2019/07/moving-to-zsh-06-customizing-the-zsh-prompt/>
# Also see comments of <https://unix.stackexchange.com/a/582702> regarding
# how to change the default prompt character.
if [[ -v SSH_CLIENT ]]
then
    # PROMPT='%B%(?.%F{green}✔.%F{red}✘%?) %F{magenta}%m:%3~%(!:#:>)%f%b '
    PROMPT='%B%(?.%F{green}✔%f.%F{red}✘|%?%f) %F{magenta}%m:%6(~.%-2~/…/%3~.%~)%(!:#:>)%f%b '
else
    # PROMPT='%B%(?.%F{green}✔.%F{red}✘%?) %F{magenta}%3~%(!:#:>)%f%b '
    PROMPT='%B%(?.%F{green}✔%f.%F{red}✘|%?%f) %F{magenta}%6(~.%-2~/…/%3~.%~)%(!:#:>)%f%b '
fi
# $git_super_status supplied by zsh-git-prompt add-on.
RPROMPT='$(git_super_status)'


#####################################################################
# Set up Perl to use "local::lib".
eval "$(perl -I${HOME}/Library/perl5/lib/perl5 -Mlocal::lib=${HOME}/Library/perl5)"


#####################################################################
# Shell add-ons.

# automatic completion suggestions
source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
# use a slightly lighter shade of grey
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=246"

# git prompt
source /usr/local/opt/zsh-git-prompt/zshrc.sh
# use Haskell executable (hacked into place - likely to break on update!)
if [[ -e /usr/local/opt/zsh-git-prompt/src/.bin/gitstatus ]]
then
    export GIT_PROMPT_EXECUTABLE="haskell"
fi
# set colors to more or less match git status config; defaults are OK for most
# branch: black bold underline (note: don't reset_color at the end as it kills
# all formatting)
export ZSH_THEME_GIT_PROMPT_BRANCH="%{\e[$color[underline]m$fg_bold[black]%}"
# staged (= added): green
export ZSH_THEME_GIT_PROMPT_STAGED="%{$fg[green]●%G$fg[black]${reset_color}%}"
# changed: red
export ZSH_THEME_GIT_PROMPT_CHANGED="%{$fg[red]✚%G$fg[black]${reset_color}%}"

# vi mode
# source /usr/local/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh

# suggest existing aliases
source /usr/local/share/zsh-you-should-use/you-should-use.plugin.zsh

# syntax highlighting - MUST be loaded last!
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
