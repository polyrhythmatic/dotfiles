# Install Homebrew

ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew tap homebrew/versions
brew tap homebrew/dupes
brew tap buo/cask-upgrade
brew update
brew upgrade

# Install packages

apps=(
  bash-completion
  coreutils
  cmake
  ffmpeg --with-libass --with-fontconfig
  giflossy
  git
  imagemagick --with-fontconfig
  mas
  mongodb --with-openssl
  python
  python3
  shellcheck
  wget
)

brew install "${apps[@]}"