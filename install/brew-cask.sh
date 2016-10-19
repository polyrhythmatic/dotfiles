# Install Caskroom

brew tap caskroom/cask
brew install brew-cask
brew tap caskroom/versions

# Install packages

apps=(
  dash
  dropbox
  firefox
  firefoxnightly
  glimmerblocker
  google-chrome
  google-chrome-canary
  google-drive
  iterm2
  macdown
  opera
  slack
  spectacle
  spotify
  sublime-text
  cyberduck
  virtualbox
  vlc
)

brew cask install "${apps[@]}"

# Quick Look Plugins (https://github.com/sindresorhus/quick-look-plugins)
brew cask install qlcolorcode qlstephen qlmarkdown quicklook-json qlprettypatch quicklook-csv betterzipql qlimagesize webpquicklook suspicious-package
