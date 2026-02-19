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

# Editors (Cursor)
export VISUAL="/Applications/Cursor.app/Contents/Resources/app/bin/code -w"
export SVN_EDITOR="/Applications/Cursor.app/Contents/Resources/app/bin/code -w"
export GIT_EDITOR="/Applications/Cursor.app/Contents/Resources/app/bin/code -w"
export EDITOR="$VISUAL"

# Source local/private profile settings if they exist
if [ -f ~/.zprofile.local ]; then
  source ~/.zprofile.local
fi
