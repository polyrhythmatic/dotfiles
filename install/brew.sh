# Install Homebrew

ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew tap homebrew/versions
brew tap homebrew/dupes
brew update
brew upgrade

# Install packages

apps=(
  bash-completion
  coreutils
  cmake
  ffmpeg
  git
  imagemagick
  mongodb --with-openssl
  python
  python3
  shellcheck
  wget
)

brew install "${apps[@]}"