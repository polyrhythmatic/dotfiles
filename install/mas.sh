#!/bin/zsh

# Ensure mas is installed
if ! command -v mas &> /dev/null; then
    echo "mas command not found. Please ensure it's installed (e.g., via Homebrew in brew.sh)."
    exit 1
fi

XCODE_APP_ID=497799835
XCODE_APP_PATH="/Applications/Xcode.app"

# Check if Xcode is already installed
if [ -d "$XCODE_APP_PATH" ]; then
    echo "Xcode appears to be already installed at $XCODE_APP_PATH."
    # You could add 'mas upgrade $XCODE_APP_ID' here if you always want the latest
else
    echo "Attempting to install Xcode (ID: $XCODE_APP_ID) via Mac App Store..."
    echo "Note: This requires you to be logged into the App Store."
    echo "This is a large download and may take a significant amount of time."
    if mas install $XCODE_APP_ID; then
        echo "Xcode installation command issued successfully via mas."
    else
        echo "WARNING: Failed to issue Xcode installation command via mas."
        echo "Please ensure you are logged into the App Store and check manually."
        # Continue script execution, as Xcode might install in the background,
        # or the user might handle it manually.
    fi
fi

# Accept Xcode license. This might need to be run after Xcode is fully installed.
# Check if xcodebuild command exists.
if command -v xcodebuild &> /dev/null; then
    echo "Attempting to accept Xcode license..."
    if sudo xcodebuild -license accept; then
      echo "Xcode license accepted."
    else
      echo "Failed to accept Xcode license automatically. May require manual intervention later."
    fi
else
    echo "xcodebuild command not found. Cannot accept license yet."
    echo "Run 'sudo xcodebuild -license accept' manually after Xcode is fully installed."
fi

echo "mas script finished."
