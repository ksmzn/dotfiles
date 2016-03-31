#!/usr/bin/env bash

# check Xcode install
if ! (type xcode-select >&- && xpath=$( xcode-select --print-path ) &&    test -d "${xpath}" && test -x "${xpath}"); then
  sudo xcodebuild -license
  xcode-select --install
fi

# check HomeBrew install
if ! [ `which brew` ]; then
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  brew update
fi

# get init files
if ! [ `which git` ]; then
  # install git
  brew install git
  # clone my dotfiles
  git clone https://github.com/ksmzn/dotfiles.git
fi

# execute ansible
if ! [ `which ansible` ]; then
  brew install ansible
  # make inventry file
  mkdir /usr/local/etc/ansible
  echo "localhost" >> /usr/local/etc/ansible/hosts
  echo 'export HOMEBREW_CASK_OPTS="--appdir=/Applications"' >> ~/.bash_profile
  source ~/.bash_profile
fi
ansible-playbook -vv localhost.yml -K

