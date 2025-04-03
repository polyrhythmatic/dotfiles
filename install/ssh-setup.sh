#!/bin/zsh

# SSH Key Setup for GitHub

SSH_DIR="$HOME/.ssh"
KEY_PATH="$SSH_DIR/id_ed25519"
CONFIG_PATH="$SSH_DIR/config"
EMAIL="sethkranzler@gmail.com"

echo "Setting up SSH key for GitHub..."

# Create .ssh directory if it doesn't exist
mkdir -p "$SSH_DIR"
chmod 700 "$SSH_DIR"

# Check if the specific key already exists
if [ -f "$KEY_PATH" ]; then
    echo "SSH key already exists at $KEY_PATH. Skipping generation."
else
    echo "Generating new Ed25519 SSH key..."
    # Generate key without passphrase for automation
    # -t type, -C comment (email), -f filepath, -N passphrase (empty)
    ssh-keygen -t ed25519 -C "$EMAIL" -f "$KEY_PATH" -N ""

    if [ $? -ne 0 ]; then
        echo "ERROR: Failed to generate SSH key."
        exit 1
    fi
    echo "New SSH key generated at $KEY_PATH"
    chmod 600 "$KEY_PATH"
    chmod 644 "${KEY_PATH}.pub" # Public key needs to be readable
fi

# Ensure ssh-agent is running (simple check/start)
# Note: More robust agent handling might be needed depending on the environment
eval "$(ssh-agent -s)" > /dev/null

# Add the key to the agent
echo "Adding SSH key to ssh-agent..."
ssh-add --apple-use-keychain "$KEY_PATH" # Use macOS keychain integration

# Create/Update SSH config file for GitHub
echo "Configuring SSH config file ($CONFIG_PATH)..."

# Ensure the config file exists
touch "$CONFIG_PATH"
chmod 600 "$CONFIG_PATH"

# Check if GitHub host entry already exists
if grep -q "Host github.com" "$CONFIG_PATH"; then
    echo "GitHub host entry already exists in $CONFIG_PATH."
    # Optional: Could add logic here to update the existing entry if needed
else
    echo "Adding GitHub host entry to $CONFIG_PATH..."
    # Add GitHub configuration
    cat >> "$CONFIG_PATH" << EOF

Host github.com
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile $KEY_PATH
EOF
    echo "GitHub host entry added."
fi

# Copy public key to clipboard and display instructions
if command -v pbcopy > /dev/null; then
    cat "${KEY_PATH}.pub" | pbcopy
    echo "\n✅ Public SSH key copied to clipboard!"
else
    echo "\n⚠️ 'pbcopy' command not found. Could not copy key to clipboard automatically."
    echo "Please copy the key manually below."
fi

echo "\n================================================================================"
echo "SSH Setup Complete!"
echo "IMPORTANT: You MUST manually add the SSH public key to your GitHub account."
echo "\n1. Go to: https://github.com/settings/keys"
echo "2. Click 'New SSH key'."
echo "3. Paste the key (which should be on your clipboard) into the 'Key' field."
echo "4. Give it a title (e.g., 'M1 MacBook') and click 'Add SSH key'."
echo "\nPublic Key ($KEY_PATH.pub):"
cat "${KEY_PATH}.pub" # Display key again in case pbcopy failed or user needs it
echo "\n================================================================================"
echo "For better security, you can add a passphrase to your key later using:"
echo "ssh-keygen -p -f $KEY_PATH"
echo "================================================================================\n"
