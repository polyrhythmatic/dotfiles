# this installs a separate version of ruby 
# than the osx default. prevents corrupting
# the default

brew install gpg2

gpg2 --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
\curl -sSL https://get.rvm.io | bash -s stable

rvm install 2.7.0
rvm use 2.7.0 --default

# install gems here
rvm install jekyll
