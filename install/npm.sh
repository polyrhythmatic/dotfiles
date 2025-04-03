brew install nvm
# Source NVM - ensure it's installed via brew first
# The path might differ slightly depending on Homebrew prefix
if [ -s "$(brew --prefix nvm)/nvm.sh" ]; then
  source "$(brew --prefix nvm)/nvm.sh"
else
  echo "NVM not found. Skipping Node installation."
  exit 1 # Or handle error appropriately
fi

echo "Installing Node.js v22 (LTS)..."
nvm install 22
nvm use 22
nvm alias default 22

# Globally install with npm

packages=(
  # http-server
  # localtunnel
  yarn
)

npm install -g "${packages[@]}"
