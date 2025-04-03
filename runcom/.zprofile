# runcom/.zprofile - Sourced on login for Zsh

# Add Homebrew managed paths (handles M1/Intel automatically)
# This line should ideally be added by the brew install script itself to ~/.zprofile,
# but we include it here for robustness or if the user manages it manually.
# The install/brew.sh script we modified earlier *should* add this to ~/.zprofile.
# If brew is installed and configured, this eval will set up the correct PATH.
if [ -x "$(command -v brew)" ]; then
  eval "$(brew shellenv)"
fi

# Migrated Environment Variables from .bash_profile
# =================================================

# NODE_PATH (Adjust for potential Homebrew prefix)
# Check if Node is installed via Homebrew and set path accordingly
if [ -x "$(command -v brew)" ]; then
  NODE_BREW_PREFIX=$(brew --prefix node 2>/dev/null)
  if [ -n "$NODE_BREW_PREFIX" ] && [ -d "$NODE_BREW_PREFIX/lib/node_modules" ]; then
    # Prepend brew node_modules path, keeping existing NODE_PATH if set
    export NODE_PATH="$NODE_BREW_PREFIX/lib/node_modules${NODE_PATH:+:$NODE_PATH}"
  fi
  # If Node isn't installed via brew, NODE_PATH won't be set here.
  # Add alternative paths below if needed.
fi

# Editors (Using VS Code)
# Ensure 'code' command is available in PATH (usually installed with VS Code Shell Command)
export VISUAL="code -w"
export SVN_EDITOR="code -w"
export GIT_EDITOR="code -w"
export EDITOR="$VISUAL" # Use VISUAL as the default EDITOR

# Custom PATH additions
# =====================
# Add any custom paths *not* managed by Homebrew here.
# The main Homebrew paths are handled by 'brew shellenv' above.
# Add other custom paths as needed:
# export PATH="/path/to/my/custom/bin:$PATH"


# RVM Initialization (Load RVM *after* PATH is potentially modified)
# =====================
# Check if the RVM script exists before sourcing
# Standard user install location:
if [[ -s "$HOME/.rvm/scripts/rvm" ]]; then
  source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
# Potential Homebrew install location (less common for RVM):
elif [[ -s "$(brew --prefix rvm 2>/dev/null)/scripts/rvm" ]]; then
   source "$(brew --prefix rvm)/scripts/rvm"
fi

# Note: NVM and Pyenv initializations are typically handled in .zshrc
# as they often modify the interactive environment more dynamically.

# Source local/private profile settings if they exist
if [ -f ~/.zprofile.local ]; then
  source ~/.zprofile.local
fi

echo ".zprofile loaded" # Optional: Add a marker to confirm it's sourced on login
eval "$(/opt/homebrew/bin/brew shellenv)"
