copied from:

https://github.com/webpro/dotfiles
https://medium.com/@webprolific/getting-started-with-dotfiles-43c3602fd789#.bzni3bwbe

https://dotfiles.github.io

# run:

sudo softwareupdate -i -a #update

sudo shutdown -r now #reboot

xcode-select --install

TODO:

# add to brew cask file:
lastpass (needs to run /usr/local/Caskroom/lastpass/latest/LastPass Installer.app)
add android-file-transfer
add appcleaner
brew cask install macs-fan-control (try to copy settings as well)
evernote
cyberduck
skype
Tunnelblick
arduino
seil? (keymapping)
robomongo?
syphon utils (simple client, simple server)?
unity?
more here https://gist.github.com/jitendravyas/8d35b092dd9102a05ea3

use brew to replace existing apps https://github.com/exherb/homebrew-cask-replace



# maybe brew install coreutils
https://www.topbug.net/blog/2013/04/14/install-and-use-gnu-command-line-tools-in-mac-os-x/

# brew doctor

# os settings (auto hide dock, what lives in dock etc)
turn off autocorrect in safari, messages etc


# sublime
https://github.com/mrmartineau/SublimeTextSetupWiki/issues/3
copy sublime-linter user file 
install sublime-linter
install sublimelinter-json
install sublimelinter-csslint (npm install -g csslint)
install sublimelinter-contrib-sass-lint (npm install -g sass-lint)
install sublimelinter-jshint (npm install -g jshint)
SublimeLinter-eslint (npm install -g eslint
)
install sublimelinter-pylint (pip install pylint)
install sublimelinter-contrib-glsl (needs special install https://github.com/numb3r23/SublimeLinter-contrib-glsl)
install sublimelinter-contrib-htmllint (npm install -g htmllint-cli)

## important - have to fix  PATH linking 
in .profile .mkshrc .bashrc  and.zshrc."
this is for RVM and NVM linking

# python
virtualenv

