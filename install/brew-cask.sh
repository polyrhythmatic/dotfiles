# Install packages
echo "Installing XQuartz (dependency for some apps)..."
brew install --cask xquartz # has to be installed before fontforge

apps=(
  appcleaner
  claude-code
  firefox
  figma
  ghostty
  google-chrome
  google-drive
  iterm2
  rectangle
  slack
  suspicious-package
  visual-studio-code
  vlc
)

# QuickLook plugins
quicklook=(
  qlcolorcode
  qlstephen
  qlmarkdown
  quicklook-json
)

echo "Installing cask applications..."
brew install --cask "${apps[@]}"

echo "Installing QuickLook plugins..."
brew install --cask "${quicklook[@]}"
