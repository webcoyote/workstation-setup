#!/bin/bash

# Ensure soloist installed
if ! which soloist >/dev/null 2>/dev/null; then
  # TODO: script this to work with/without ruby & rvm
  echo "install soloist"
  exit 1
fi

# Webcoyote version of pivotal workstation
if [[ -d pivotal_workstation ]]; then
  cd pivotal_workstation && git pull && cd ..
else
  git clone https://github.com/webcoyote/pivotal_workstation.git
fi

# DMG for Mac
case $OSTYPE in darwin*)
  if [[ -d dmg ]]; then
    cd dmg && git pull && cd ..
  else
    git clone https://github.com/opscode-cookbooks/dmg.git
  fi
esac

# Build the system
soloist
