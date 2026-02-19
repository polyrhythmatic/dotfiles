# runcom/.zprofile - Sourced on login for Zsh

# Add Homebrew managed paths (handles Apple Silicon/Intel automatically)
if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x /usr/local/bin/brew ]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# NODE_PATH
if [ -x "$(command -v brew)" ]; then
  NODE_BREW_PREFIX=$(brew --prefix node 2>/dev/null)
  if [ -n "$NODE_BREW_PREFIX" ] && [ -d "$NODE_BREW_PREFIX/lib/node_modules" ]; then
    export NODE_PATH="$NODE_BREW_PREFIX/lib/node_modules${NODE_PATH:+:$NODE_PATH}"
  fi
fi

# XDG Base Directories
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

# Editors (Cursor with vim fallback)
if [ -x "/Applications/Cursor.app/Contents/Resources/app/bin/code" ]; then
  export VISUAL="/Applications/Cursor.app/Contents/Resources/app/bin/code -w"
else
  export VISUAL="vim"
fi
export EDITOR="$VISUAL"
export SVN_EDITOR="$VISUAL"
export GIT_EDITOR="$VISUAL"

# Source local/private profile settings if they exist
if [ -f ~/.zprofile.local ]; then
  source ~/.zprofile.local
fi
