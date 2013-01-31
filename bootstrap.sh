#!/bin/bash
# bootstrap.sh by Patrick Wyatt 1/30/2013
# Prepares a Mac/Linux box to be configured
# with RVM, soloist and configure-system.sh


#######################################################
# Set the user/repo used to configure your computer
#   EDIT ME
GITHUB_USER=webcoyote
#   EDIT END
#######################################################


# Install RVM
if ! (rvm --version 2>/dev/null >/dev/null) ; then
  \curl -L https://get.rvm.io | bash -s stable
  source ~/.rvm/scripts/rvm
  if ! (rvm --version 2>/dev/null >/dev/null) ; then
    export PATH=/home/$USER/.rvm/bin:$PATH
  fi
fi
rvm reload

# Install Ruby 1.9.3 with packages
  rvm pkg install --verify-downloads 1 readline </dev/null
  rvm pkg install --verify-downloads 1 autoconf </dev/null
  rvm pkg install --verify-downloads 1 openssl  </dev/null
  rvm pkg install --verify-downloads 1 zlib     </dev/null
  rvm install 1.9.3-p374 </dev/null

# Make .ssh directory
  mkdir -p ~/.ssh
  chown $USER:$USER ~/.ssh
  chmod 0700 ~/.ssh

# Make known hosts file
  touch ~/.ssh/known_hosts
  chown $USER:$USER ~/.ssh/known_hosts
  chmod 0644 ~/.ssh/known_hosts

# Add github key
  GITHUB_KEY="github.com,207.97.227.239 ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ=="
  if ! (grep "$GITHUB_KEY" ~/.ssh/known_hosts >/dev/null) ; then
    echo "$GITHUB_KEY" >> ~/.ssh/known_hosts
  fi

# Clone workstation setup project
  mkdir -p ~/dev
  cd ~/dev
  git clone git@github.com:$GITHUB_USER/workstation-setup.git </dev/null
  cd workstation-setup

# Install soloist
  rvm gemset use --create ruby-1.9.3-p374@soloist </dev/null
  gem install soloist </dev/null

# And run system configuration
  ./configure-system.sh

