# Install packages
brew cask install xquartz # has to be installed before fontforge

apps=(
  android-file-transfer
  android-studio
  appcleaner
  arduino
  appcleaner
  betterzip
  blender
  calibre
  cyberduck
  cycling74-max
  dash
  dropbox
  evernote
  firefox
  fontforge
  fritzing
  glimmerblocker
  google-chrome
  google-drive-file-stream
  inkscape
  istat-menus
  iterm2
  java
  jupyter-notebook-viewer
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
  robo-3t
  silverlight
  sketch
  skype
  slack
  spectacle
  spotify
  sublime-text
  suspicious-package
  visual-studio
  vlc
  webpquicklook
)

brew cask install "${apps[@]}"
