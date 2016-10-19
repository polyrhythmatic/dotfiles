# Install Homebrew

ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew tap homebrew/versions
brew tap homebrew/dupes
brew update
brew upgrade

# Install packages

apps=(
  coreutils
  cmake
  ffmpeg
  git
  imagemagick
  nvm
  python
  shellcheck
  wget
)

brew install "${apps[@]}"