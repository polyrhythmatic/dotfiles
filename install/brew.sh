# Install Homebrew

ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew tap buo/cask-upgrade
brew update
brew upgrade

# Install packages

apps=(
  bash-completion
  coreutils
  cmake
  ffmpeg
  giflossy
  git
  highlight
  imagemagick
  mas
  shellcheck
  wget
)

brew install "${apps[@]}"