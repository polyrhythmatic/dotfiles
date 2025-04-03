# this installs a separate version of ruby 
# than the osx default. prevents corrupting
# the default

# Install GnuPG for verifying RVM installation
echo "Installing GnuPG via Homebrew..."
brew install gnupg

# Import RVM GPG keys
echo "Importing RVM GPG keys..."
# Key for MPapis (original RVM creator)
gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
# Key for PKubowicz (current maintainer)
gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys 7D2BAF1CF37B13E2069D6956105BD0E739499BDB

# Install RVM
echo "Installing RVM (Ruby Version Manager)..."
\curl -sSL https://get.rvm.io | bash -s stable --ruby

# Source RVM for the current script session
# Check standard user install location first
if [[ -s "$HOME/.rvm/scripts/rvm" ]]; then
  source "$HOME/.rvm/scripts/rvm"
# Check potential Homebrew install location (less common)
elif [[ -s "$(brew --prefix rvm 2>/dev/null)/scripts/rvm" ]]; then
   source "$(brew --prefix rvm)/scripts/rvm"
else
  echo "RVM script not found after installation attempt. Cannot proceed with Ruby install."
  exit 1
fi


# Install Ruby 3.3 and set as default
echo "Installing Ruby 3.3..."
rvm install 3.3
echo "Setting Ruby 3.3 as default..."
rvm use 3.3 --default

# # Install gems
# echo "Installing Jekyll gem..."
# gem install jekyll

# echo "Ruby and Jekyll installation complete."
