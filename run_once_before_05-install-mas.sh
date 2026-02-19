#!/bin/bash
# Install Xcode from Mac App Store.

set -euo pipefail

if ! command -v mas &>/dev/null; then
  echo "mas not found — skipping App Store installs."
  exit 0
fi

XCODE_APP_ID=497799835
XCODE_APP_PATH="/Applications/Xcode.app"

if [ -d "$XCODE_APP_PATH" ]; then
  echo "Xcode already installed."
else
  echo "Installing Xcode via Mac App Store..."
  echo "Note: Requires App Store login. This is a large download."
  mas install $XCODE_APP_ID || echo "WARNING: Xcode install failed. Check App Store login."
fi

# Accept Xcode license if xcodebuild is available
if command -v xcodebuild &>/dev/null; then
  echo "Accepting Xcode license..."
  sudo xcodebuild -license accept 2>/dev/null || echo "Could not accept license automatically."
fi

echo "mas script finished."
