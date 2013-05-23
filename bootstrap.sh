#!/bin/bash
# bootstrap.sh by Patrick Wyatt 1/30/2013
# Prepares a Mac/Linux box to be configured using soloist


#######################################################
# Use your own repositories in marked spots:
#   EDIT ME
#     ... change things here ...
#   EDIT END
#######################################################


# install ruby if required
if ! which ruby &>/dev/null ; then
  if which brew &>/dev/null ; then
    brew install ruby
  elif which apt-get &>/dev/null ; then
    sudo apt-get install -y ruby
  elif which yum &>/dev/null ; then
    sudo yum install -y ruby
  fi
fi

# Get user's group
GROUP=$(id -G -n | cut -d ' ' -f 1)

# Configure ssh to github
  # Make .ssh directory
  mkdir -p ~/.ssh
  chown $USER:$GROUP ~/.ssh
  chmod 0700 ~/.ssh

  # Make known hosts file
  touch ~/.ssh/known_hosts
  chown $USER:$GROUP ~/.ssh/known_hosts
  chmod 0644 ~/.ssh/known_hosts

  # Add github key
  GITHUB_KEY="github.com,207.97.227.239 ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ=="
  if ! (grep "$GITHUB_KEY" ~/.ssh/known_hosts >/dev/null) ; then
    echo "$GITHUB_KEY" >> ~/.ssh/known_hosts
  fi


# Clone workstation setup project
  mkdir -p ~/dev
  cd ~/dev
  if [ ! -d workstation-setup ]; then
    # EDIT ME: select repo for workstation-setup
    git clone git://github.com/webcoyote/workstation-setup.git </dev/null
    # EDIT END
  fi
  cd workstation-setup


# Install/update git archives
  # $1 = repostiory owner on github
  # $2 = archive name/directory
  function update_github_archive () {
    mkdir -p cookbooks; cd cookbooks
    if [[ -d $2 ]]; then
      cd $2 && git pull && cd ..
    else
      git clone git://github.com/$1/$2.git </dev/null
    fi
    cd ..
  }

  # EDIT ME: select repos containing your recipes
  update_github_archive webcoyote pivotal_workstation
  update_github_archive opscode-cookbooks apt
  update_github_archive opscode-cookbooks dmg
  update_github_archive opscode-cookbooks yum
  # EDIT END


# Install soloist in system ruby
  sudo gem install soloist </dev/null


# And run system configuration
  ./configure-system.sh

