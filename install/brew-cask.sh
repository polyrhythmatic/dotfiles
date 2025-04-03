# Install packages
echo "Installing XQuartz (dependency for some apps)..."
brew install --cask xquartz # has to be installed before fontforge

apps=(
  # android-file-transfer
  # android-studio
  appcleaner # Removed duplicate
  # arduino
  # betterzip
  # blender
  # calibre
  # cyberduck
  # cycling74-max
  # dash
  # dropbox
  # evernote
  firefox
  # fontforge
  # fritzing
  # glimmerblocker # Removed (outdated)
  google-chrome
  google-drive # Updated name
  # inkscape
  # istat-menus
  # iterm2
  # java
  # jupyter-notebook-viewer
  # lastpass
  # macdown
  # macs-fan-control
  # opera
  # processing
  # qlcolorcode
  # qlimagesize
  # qlmarkdown
  # qlprettypatch
  # qlstephen
  # quicklook-csv
  # quicklook-json
  rectangle # Replaced spectacle
  # robo-3t
  # silverlight # Removed (outdated)
  # sketch
  # skype
  slack
  # spotify
  # sublime-text # Removed
  suspicious-package
  visual-studio-code # Added/Replaced visual-studio
  vlc
  # webpquicklook
)

echo "Installing other cask applications..."
brew install --cask "${apps[@]}"
