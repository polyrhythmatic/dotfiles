brew install nvm
source $(brew --prefix nvm)/nvm.sh

nvm install 6
nvm use 6
nvm alias default 6

# Globally install with npm

packages=(
  grunt
  gulp
  http-server
  localtunnel
  nodemon
  webpack
)

npm install -g "${packages[@]}"