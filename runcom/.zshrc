# Migrated from .bash_profile

# Environment Variables (Moved to .zprofile where appropriate)
# =====================
# Note: PATH, EDITOR variables, NODE_PATH are typically set in .zprofile

# Configurations
# =====================
# GIT_MERGE_AUTO_EDIT
# This variable configures git to not require a message when you merge.
export GIT_MERGE_AUTOEDIT='no'

# Helpful Functions
# =====================

# A function to CD into the desktop from anywhere
# so you just type desktop.
# HINT: It uses the built in USER variable to know your OS X username

# USE: desktop
#      desktop subfolder
function desktop {
  cd /Users/$USER/Desktop/$@
}

# A function to easily grep for a matching process
# USE: psg postgres
function psg {
  FIRST=$(echo $1 | sed -e 's/^\(.\).*/\1/')
  REST=$(echo $1 | sed -e 's/^.\(.*\)/\1/')
  ps aux | grep "[$FIRST]$REST"
}

# A function to extract correctly any archive based on extension
# USE: extract imazip.zip
#      extract imatar.tar
function extract () {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)  tar xjf $1      ;;
            *.tar.gz)   tar xzf $1      ;;
            *.bz2)      bunzip2 $1      ;;
            *.rar)      unrar x $1      ;; # Note: requires 'unrar' or 'rar' package from Homebrew
            *.gz)       gunzip $1       ;;
            *.tar)      tar xf $1       ;;
            *.tbz2)     tar xjf $1      ;;
            *.tgz)      tar xzf $1      ;;
            *.zip)      unzip $1        ;;
            *.Z)        uncompress $1   ;;
            *)          echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# A function to easily grep for a matching file
# USE: lg filename
function lg {
  ls -la | grep "$@"
}

# Aliases
# =====================
  # LS
  alias l='ls -lah'

  # Git
  alias gst="git status"
  alias gl="git pull"
  alias gp="git push"
  # alias gd="git diff | mate" # Changed editor below
  alias gc="git commit -v"
  alias gca="git commit -v -a"
  alias gb="git branch"
  alias gba="git branch -a"
  alias gcam="git commit -am"
  # alias gbb="git branch -b" # 'git switch -c' or 'git checkout -b' is preferred now

  # open files with "chrome ____"
  alias chrome="open -a 'Google Chrome'"

# Version Managers & Environment Setup
# =====================

# RVM
# Load RVM into a shell session *as a function*
# Must be sourced *after* PATH is set, typically in .zprofile or at the end of .zshrc
# [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

# NVM
# loads NVM
export NVM_DIR="$HOME/.nvm"
# Source NVM script - ensure nvm is installed via brew first
# The path might differ slightly depending on Homebrew prefix
if [ -s "$(brew --prefix nvm)/nvm.sh" ]; then
  source "$(brew --prefix nvm)/nvm.sh"
fi

# Pyenv
# Initialize pyenv if available
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

# History - Zsh specific settings
# =====================
export HISTSIZE=32768
export SAVEHIST=$HISTSIZE # In zsh, SAVEHIST is the size of the history file
export HISTFILE=~/.zsh_history # Default location for zsh history
setopt HIST_IGNORE_DUPS        # Don't record dupes in history
setopt HIST_IGNORE_ALL_DUPS    # Delete old recorded dupes if new one added
setopt HIST_IGNORE_SPACE       # Don't record commands starting with space
setopt HIST_FIND_NO_DUPS       # Don't show dupes when searching history
setopt HIST_SAVE_NO_DUPS       # Only save unique history entries
setopt EXTENDED_HISTORY        # Write the history file in the ":start:elapsed;command" format.
setopt SHARE_HISTORY           # Share history between terminals
setopt INC_APPEND_HISTORY      # Write history entries as they happen, not just on exit

# Zsh Completion System (basic setup)
# =====================
# Needs to be after potential PATH changes from RVM/NVM/Pyenv if they affect completion paths
autoload -Uz compinit && compinit

# Key Bindings (Example - adjust as needed)
# =====================
# bindkey -e # Emacs style keybindings (default)
# bindkey -v # Vi style keybindings

# Case-Insensitive Auto Completion (Zsh way)
# =====================
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' # Case-insensitive matching

# Editors (Set in .zprofile is often better, but can be here too)
# =====================
# Tells your shell that when a program requires various editors, use subl.
# The -w flag tells your shell to wait until sublime exits
# export VISUAL="subl -w"
# export SVN_EDITOR="subl -w"
# export GIT_EDITOR="subl -w"
# export EDITOR="subl -w"
# Consider using 'code -w' for VS Code if that's your preferred editor

# Add custom prompt setup here if desired, e.g., using Zsh's prompt themes or custom functions.
# Example simple prompt:
# PROMPT='%n@%m %1~ %# '

# Source local/private settings if they exist
if [ -f ~/.zshrc.local ]; then
  source ~/.zshrc.local
fi
