# Install packages

apps=(
  appcleaner
  dash
  dropbox
  firefox
  firefoxnightly
  glimmerblocker
  google-chrome
  google-chrome-canary
  google-drive
  gpgtools
  iterm2
  java
  lastpass
  macdown
  macs-fan-control
  opera
  silverlight
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
