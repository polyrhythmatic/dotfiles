# Configurations
# =====================
# GIT_MERGE_AUTO_EDIT
# This variable configures git to not require a message when you merge.
export GIT_MERGE_AUTOEDIT='no'

# Helpful Functions
# =====================

# A function to CD into the desktop from anywhere
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
            *.rar)      unrar x $1      ;;
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
  alias gc="git commit -v"
  alias gca="git commit -v -a"
  alias gb="git branch"
  alias gba="git branch -a"
  alias gcam="git commit -am"

  # open files with "chrome ____"
  alias chrome="open -a 'Google Chrome'"

  # Cursor editor
  alias code="/Applications/Cursor.app/Contents/Resources/app/bin/code"

# Version Managers & Environment Setup
# =====================

# fnm (Fast Node Manager)
eval "$(fnm env --use-on-cd)"

# History - Zsh specific settings
# =====================
export HISTSIZE=32768
export SAVEHIST=$HISTSIZE
export HISTFILE=~/.zsh_history
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
setopt EXTENDED_HISTORY
setopt SHARE_HISTORY
setopt INC_APPEND_HISTORY

# Zsh Completion System
# =====================
autoload -Uz compinit && compinit

# Case-Insensitive Auto Completion
# =====================
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Shell Plugins
# =====================

# fzf key bindings and completion
if [ -f /opt/homebrew/opt/fzf/shell/key-bindings.zsh ]; then
  source /opt/homebrew/opt/fzf/shell/key-bindings.zsh
fi
if [ -f /opt/homebrew/opt/fzf/shell/completion.zsh ]; then
  source /opt/homebrew/opt/fzf/shell/completion.zsh
fi

# zsh-autosuggestions
if [ -f /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
  source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# zsh-syntax-highlighting (must be last plugin sourced)
if [ -f /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
  source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# Prompt
# =====================

# Starship prompt (must be last — wraps precmd)
eval "$(starship init zsh)"

# Source local/private settings if they exist
if [ -f ~/.zshrc.local ]; then
  source ~/.zshrc.local
fi
