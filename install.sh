#!/bin/zsh

# Get current dir (so run this script from anywhere)

export DOTFILES_DIR
DOTFILES_DIR="$( cd "$( dirname "${(%):-%N}" )" && pwd )"

# Update dotfiles itself first
# if [ -d "$DOTFILES_DIR/.git" ]; then
#   echo "Updating dotfiles repository..."
#   git --work-tree="$DOTFILES_DIR" --git-dir="$DOTFILES_DIR/.git" pull origin master
# else
#   echo "Dotfiles repository is not a git repository. Skipping update."
# fi

# Create symlinks for configuration files
echo "Creating symlinks for configuration files..."
ln -sfv "$DOTFILES_DIR/runcom/.zshrc" ~
ln -sfv "$DOTFILES_DIR/runcom/.zprofile" ~ # Added symlink for .zprofile
ln -sfv "$DOTFILES_DIR/.gitconfig" ~ # Updated path for .gitconfig
ln -sfv "$DOTFILES_DIR/.gitignore" ~ # Added symlink for global .gitignore
ln -sfv "$DOTFILES_DIR/etc/.mackup.cfg" ~/.mackup.cfg # Added symlink for Mackup config

# Package managers & packages
echo "Installing packages and tools..."
. "$DOTFILES_DIR/install/brew.sh"

. "$DOTFILES_DIR/install/npm.sh"
# . "$DOTFILES_DIR/install/gem.sh" # Temporarily removing until I have time to do more ruby research

if [ "$(uname)" = "Darwin" ]; then # Changed == to =
  echo "Running macOS specific installations (mas, brew-cask)..."
  . "$DOTFILES_DIR/install/mas.sh"
  . "$DOTFILES_DIR/install/brew-cask.sh"
fi

# Run SSH setup script
echo "Setting up SSH configuration..."
. "$DOTFILES_DIR/install/ssh-setup.sh"

# Apply macOS preferences
if [ "$(uname)" = "Darwin" ]; then # Changed == to =
  echo "Applying macOS preferences..."
  . "$DOTFILES_DIR/install/macos.sh"
fi

# Restore application settings using Mackup
if command -v mackup &> /dev/null; then
  echo "Running Mackup backup (to capture any initial settings)..."
  mackup backup -f # Force backup without prompt
  echo "Running Mackup restore (to apply synced settings)..."
  mackup restore -f # Force restore without prompt
else
  echo "Mackup command not found. Skipping settings restore."
fi

echo "✅ Dotfiles installation complete!"
