# Install packages

apps=(
  android-file-transfer
  android-studio
  appcleaner
  arduino
  appcleaner
  audacity
  audacity-lame-library
  betterzipql
  blender
  calibre
  cyberduck
  cycling74-max
  dash
  dropbox
  evernote
  firefox
  firefoxnightly
  fontforge
  fritzing
  glimmerblocker
  google-chrome
  google-chrome-canary
  google-drive
  gpgtools
  inkscape
  istat-menus
  iterm2
  java
  lastpass
  macdown
  macs-fan-control
  opera
  processing
  qlcolorcode
  qlimagesize
  qlmarkdown
  qlprettypatch
  qlstephen
  quicklook-csv
  quicklook-json
  robomongo
  seil
  silverlight
  sketch
  skype
  slack
  spectacle
  spotify
  sublime-text
  suspicious-package
  virtualbox
  vlc
  webpquicklook
  xquartz
)

brew cask install "${apps[@]}"

# Quick Look Plugins (https://github.com/sindresorhus/quick-look-plugins)
brew cask install qlcolorcode qlstephen qlmarkdown quicklook-json qlprettypatch quicklook-csv betterzipql qlimagesize webpquicklook suspicious-package
