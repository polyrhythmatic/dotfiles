copied from:

https://github.com/webpro/dotfiles
https://medium.com/@webprolific/getting-started-with-dotfiles-43c3602fd789#.bzni3bwbe

https://dotfiles.github.io

# run:

sudo softwareupdate -i -a #update

sudo shutdown -r now #reboot

xcode-select --install

# Updating brew
uses [homebrew-cask-upgrade](https://github.com/buo/homebrew-cask-upgrade)
run:
brew update
brew cu


TODO:

# add to brew cask file:
lastpass (works but needs to run /usr/local/Caskroom/lastpass/latest/LastPass Installer.app)

unity?
more here https://gist.github.com/jitendravyas/8d35b092dd9102a05ea3

brew cask install unity
brew cask install cycling74-max < this works beautifully
brew cask install ableton-live < test these out
synology stuff
GPG?
https://github.com/caskroom/homebrew-cask/blob/master/Casks/prey.rb add prey and api key

# maybe brew install coreutils
https://www.topbug.net/blog/2013/04/14/install-and-use-gnu-command-line-tools-in-mac-os-x/

# brew doctor

# os settings (auto hide dock, what lives in dock etc)
turn off autocorrect in safari, messages etc
https://github.com/herrbischoff/awesome-osx-command-line


# sublime
https://github.com/mrmartineau/SublimeTextSetupWiki/issues/3
copy sublime-linter user file 
install sublime-linter
install sublimelinter-json
install sublimelinter-csslint (npm install -g csslint)
install sublimelinter-contrib-sass-lint (npm install -g sass-lint)
~~install sublimelinter-jshint (npm install -g jshint)~~ use eslint now 
SublimeLinter-eslint (npm install -g eslint
)
install sublimelinter-pylint (pip install pylint)
install sublimelinter-contrib-glsl (needs special install https://github.com/numb3r23/SublimeLinter-contrib-glsl)
install sublimelinter-contrib-htmllint (npm install -g htmllint-cli)

babel for syntax highlighting https://packagecontrol.io/packages/Babel
and oceanic theme https://packagecontrol.io/packages/Oceanic%20Next%20Color%20Scheme

## important - have to fix  PATH linking 
in .profile .mkshrc .bashrc  and.zshrc."
this is for RVM and NVM linking

# python
virtualenv

# mackup
set up mackup to backup everything else that is not already in the dot files
set up and test macs fan control (plist in /Library/Preferences/com.crystalidea.macsfancontrol.plist )
sublime text
istat
dash
seil (look into other keymapper)

# go through this
https://github.com/jaywcjlove/awesome-mac/blob/master/README-en.md

#mongodb?

# mas
incorporate this to install apple store apps
https://github.com/mas-cli/mas
added sh file but need to make sure it runs

#disable bonjour in cyberduck
defaults write ch.sudo.cyberduck rendezvous.notification.limit 0
