brew install nvm
source $(brew --prefix nvm)/nvm.sh

nvm install 12
nvm use 12
nvm alias default 12

# Globally install with npm

packages=(
  http-server
  localtunnel
  yarn
)

npm install -g "${packages[@]}"
