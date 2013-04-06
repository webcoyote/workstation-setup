#!/bin/bash
# configure-system.sh by Patrick Wyatt 1/26/2013
# Configures a Mac/Linux box with development software


#######################################################
# Add your own recipes in marked spots:
#   EDIT ME
#     ... change things here ...
#   EDIT END
#######################################################


# Make sure script runs from the script's directory
# http://stackoverflow.com/questions/59895/can-a-bash-script-tell-what-directory-its-stored-in
  SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
  cd "$SCRIPT_DIR"


# Ensure soloist installed
  if ! which soloist &>/dev/null ; then
    echo "You need to run './bootstrap.sh' to install soloist"
    exit 1
  fi


# Defining HEREDOCS "almost just like" Ruby
# http://ss64.com/bash/read.html
# http://stackoverflow.com/questions/1167746/how-to-assign-a-heredoc-value-to-a-variable-in-bash
  heredoc(){ IFS='\n' read -r -d '' ${1} || true; }


# EDIT ME: define OS- and distro- specific recipes to run
heredoc MAC_RECIPES << EOF
# mac
- pivotal_workstation::iterm2
- pivotal_workstation::diff_merge
- pivotal_workstation::finder_display_full_path
EOF
heredoc LINUX_RECIPES << EOF
# linux
- pivotal_workstation::xmonad
- pivotal_workstation::meld
EOF
heredoc CENTOS_RECIPES << EOF
# centos
- yum::epel # Enterprise Linux
- yum::remi # for Firefox
EOF
heredoc UBUNTU_RECIPES << EOF
# ubuntu
# <none>
EOF
# EDIT END


# Choose specific recipes
if (uname -a | grep "Ubuntu") &>/dev/null ; then
    DISTRO_RECIPES="$UBUNTU_RECIPES"
  else
    DISTRO_RECIPES="$CENTOS_RECIPES"
  fi

  case "$OSTYPE" in
    darwin*)
      OS_RECIPES="$MAC_RECIPES"
      DISTRO_RECIPES=""
    ;;
    linux*) OS_RECIPES="$LINUX_RECIPES" ;;
    *) echo Unknown OS: $OSTYPE; exit 1 ;;
  esac


# Strip trailing newlines from recipes
  OS_RECIPES=$(echo "$OS_RECIPES" | sed 's/ *$//g')
  DISTRO_RECIPES=$(echo "$DISTRO_RECIPES" | sed 's/ *$//g')


# EDIT ME: define recipes and attributes
cat > soloistrc << EOF
# This file generated by $0; do not edit directly
cookbook_paths:
- $PWD/cookbooks

recipes:
$DISTRO_RECIPES
$OS_RECIPES
- pivotal_workstation::wget
- pivotal_workstation::git
- pivotal_workstation::golang
- pivotal_workstation::oh_my_zsh
- pivotal_workstation::zsh
- pivotal_workstation::workspace_directory
- pivotal_workstation::git_projects
- pivotal_workstation::firefox
- pivotal_workstation::sublime_text

node_attributes:
  workspace_directory: dev

  git:
    - - user.name
      - Patrick Wyatt
    - - user.email
      - pat@codeofhonor.com
    - - color.ui
      - true
    - - difftool.prompt
      - false
    - - alias.lol
      - log --graph --decorate --oneline
    - - alias.lola
      - log --graph --decorate --oneline --all

  git_projects:
    # put the dotfiles in the home directory
    - - .dotfiles
      - git://github.com/webcoyote/dotfiles.git
      - .

    # Store my other projects in "~/dev"
    - - network-traffic-visualize
      - git://github.com/webcoyote/network.git


EOF
# EDIT END

echo
echo "soloistrc file prepared"
echo "run 'soloist' to build your computer"

