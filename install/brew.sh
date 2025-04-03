#!/bin/zsh

# Install Homebrew if it's not already installed
if ! command -v brew &> /dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Determine architecture and set Homebrew path accordingly
  if [[ "$(uname -m)" == "arm64" ]]; then
    # Apple Silicon M1/M2/M3
    HOMEBREW_PATH="/opt/homebrew/bin"
  else
    # Intel
    HOMEBREW_PATH="/usr/local/bin"
  fi

  # Add Homebrew to PATH if it's not already there
  if ! echo "$PATH" | grep -q "$HOMEBREW_PATH"; then
    export PATH="$HOMEBREW_PATH:$PATH"
    echo "Added $HOMEBREW_PATH to PATH."
  fi

  # Add brew to shell profile for future sessions if it's not already there
  BREW_SHELLENV='eval "$('$HOMEBREW_PATH/brew' shellenv)"'
  if ! grep -q "$BREW_SHELLENV" ~/.zprofile; then
    echo "$BREW_SHELLENV" >> ~/.zprofile
    echo "Added brew shellenv to ~/.zprofile."
  fi

  # Source brew shellenv for this session
  eval "$($HOMEBREW_PATH/brew shellenv)"

else
  echo "Homebrew already installed."
fi

# Update and upgrade existing Homebrew installation
echo "Updating and upgrading Homebrew..."

brew update
brew upgrade

# Install packages

apps=(
  coreutils
  cmake
  ffmpeg
  # giflossy # gif optimizer
  git # version control
  # highlight # syntax highlighter
  imagemagick # image manipulation
  mas # mac app store cli
  mackup # Added Mackup for settings sync
  shellcheck # shell script linter
  wget # file downloader
)

# Install the packages
brew install "${apps[@]}"
