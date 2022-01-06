#####################################################################
# Completions.

# The following lines were added by compinstall

zstyle ':completion:*' completer _complete _ignored _approximate
zstyle ':completion:*' matcher-list 'm:{[:lower:]}={[:upper:]}' 'r:|[._-]=* r:|=*'
zstyle :compinstall filename '/Users/nstanger/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall


#####################################################################
# Useful configuration from <https://scriptingosx.com/2019/06/moving-to-zsh/>.

# Case-insensitive globbing
setopt NO_CASE_GLOB

# Automatically add "cd" to bare directories
setopt AUTO_CD

# Shell history
# extended history information
setopt EXTENDED_HISTORY
# share history across multiple zsh sessions
setopt SHARE_HISTORY
# append to history
setopt APPEND_HISTORY
# adds commands as they are typed, not at shell exit
setopt INC_APPEND_HISTORY
# expire duplicates first
setopt HIST_EXPIRE_DUPS_FIRST 
# do not store duplications
setopt HIST_IGNORE_DUPS
# ignore duplicates when searching
setopt HIST_FIND_NO_DUPS
# removes blank lines from history
setopt HIST_REDUCE_BLANKS
# verify !! command substitution
setopt HIST_VERIFY

# Auto-correction
setopt CORRECT
setopt CORRECT_ALL

# Search instead of just up and down arrow (cf. ^R)
bindkey "^[[A" up-line-or-search # up arrow bindkey
bindkey "^[[B" down-line-or-search # down arrow


#####################################################################
# Configuration from old tcsh rc.shared.
bindkey "\e[3~" delete-char
bindkey "^U" backward-kill-line


#####################################################################
# Configuration from old tcsh aliases.shared.
alias empty="rm -rf ~/.Trash/*"
alias unlocktrash="sudo chown -R ${USER}:${GROUP} ~/.Trash/*"
# note: requires Homebrew installed gls
alias -g ls="/usr/local/bin/gls --classify --color=auto"
alias -g l="ls -l"
alias -g ll="ls -la"
alias -g l@="/bin/ls -l@"
alias -g ll@="/bin/ls -al@"
alias man="/usr/local/bin/openman"
alias -g rm="rm -i"
alias locate="/usr/local/bin/glocate -d /var/db/locate.database"
# alias smbclient="rlwrap /opt/local/bin/smbclient"
# alias sqlplus="rlwrap /Users/nstanger/bin/sqlplus"
alias -g beep="tput bel"
alias -g grep="/usr/local/bin/ggrep --color=auto"


#####################################################################
# Configuration from old tcsh aliases.mine.

# Set Terminal window and tab title
alias winname='printf "\033]2;%s\a"'
alias tabname='printf "\033]1;%s\a"'

# Various ISPMS and other related scripts
alias load_assessment-"php $TEACHING_SHARED/ISPMS/scripts/marking/load_assessment/load_assessment.php"
alias merge="php $TEACHING_SHARED/ISPMS/scripts/marking/results_reporting/merge.php"
alias marking_form="xrdb < ~/.Xdefaults; tclsh $TEACHING_SHARED/ISPMS/scripts/marking/marking-form.tcl"
alias process_podcast="python $TEACHING_SHARED/Tools/process_podcast/process_podcast.py"
alias process_submissions="python $TEACHING_SHARED/ISPMS/scripts/marking/load_assessment/process_submissions.py"

# Android SDK tools
alias adb="~/Library/Android/sdk/platform-tools/adb"
alias fastboot="~/Library/Android/sdk/platform-tools/fastboot"
alias android="~/Library/Android/sdk/tools/android"
#alias rstudio="open /Applications/RStudio.app"

# Java
alias rstudio="sh -c 'unset JAVA_HOME; R CMD open -a /Applications/RStudio.app'"
alias java_home="/usr/libexec/java_home"
# Homebrew plantuml already does headless
# alias plantuml="/usr/bin/java -Djava.awt.headless=true -jar /usr/local/bin/plantuml.jar"

# Miscellaneous
eval `/usr/local/bin/thefuck --alias`


#####################################################################
# Configuration from old environment.shared and environment.mine
export ALL_PAPERS_ROOT="${HOME}/Documents/Teaching"
export CLASSPATH="${CLASSPATH}:/Users/nstanger/Research/PhD/Swift/classes"
export DBCOURSES_WEB_ROOT="/Volumes/dbcourses"
# export HANDBOOK_INSTALL_ROOT="/mnt/shares/infosci-shared/Teaching/DatabaseCourses/Web_Deployment"
# export PRINTER="IS_07th_Floor"
export TEACHING_SHARED="${HOME}/Documents/Teaching/Shared"
export XSLT="saxon-b"


#####################################################################
# Configuration from old .tcshrc
# if ($?DISPLAY) then
# #     #/opt/local/bin/xrdb < ~/.Xdefaults
#     /opt/local/bin/xrdb -merge $HOME/.Xresources
# else
if [[ -v SSH_CLIENT ]]
then
    # Hack to ensure that SSH logins still have environment variables that are
    # specified using launchctl setenv in /etc/environment. Process is to extract
    # the relevant lines into correct environment variable form and evaluate that
    # directly.

    # I tried this with awk, but it kept chopping the ) off the the end of the
    # $() shell escape that defines JAVA_HOME.
    # eval $(awk 'BEGIN {pattern = "^/bin/launchctl setenv"} $0 ~ pattern {print "export " $3 "=" $4 ";"}' /etc/environment)

    # sed does the job once you find the right pattern. \w doesn't seem to work
    # in BSD sed (escaping?), but [[:alnum:]_] works in both BSD and GNU sed
    # with the -E option.
    eval $(grep '^/bin/launchctl setenv' /etc/environment | cut -d ' ' -f 3- | sed -E 's/^([[:alnum:]_]+) (.+)$/export \1=\2;/g')
    
    # Also set base paths correctly, as per /etc/environment.
    if [[ -e /usr/libexec/path_helper ]] then
        PATH=""
        MANPATH=""
        eval $(/usr/libexec/path_helper -s)
    fi
fi


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
# Path. We can't just put files in /etc/paths.d because they are added
# at the end not at the front.
homebrew_paths=$(tr '\n' ':' < ~/.homebrew_paths)
export PATH="${homebrew_paths}${PATH}:${HOME}/bin:/Users/Shared/bin"


#####################################################################
# Shell prompt.
# <https://scriptingosx.com/2019/07/moving-to-zsh-06-customizing-the-zsh-prompt/>
# Also see comments of <https://unix.stackexchange.com/a/582702> regarding
# how to change the default prompt character.
if [[ -v SSH_CLIENT ]]
then
    PROMPT='%B%(?.%F{green}✔.%F{red}✘%?) %F{magenta}%m:%3~%(!:#:>)%b '
else
    PROMPT='%B%(?.%F{green}✔.%F{red}✘%?) %F{magenta}%3~%(!:#:>)%b '
fi
RPROMPT='$(git_super_status)'


#####################################################################
# Shell add-ons.

# automatic completion suggestions
source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# git prompt
source /usr/local/opt/zsh-git-prompt/zshrc.sh

# vi mode
# source /usr/local/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh

# suggest existing aliases
source /usr/local/share/zsh-you-should-use/you-should-use.plugin.zsh

# syntax highlighting - MUST appear last!
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
