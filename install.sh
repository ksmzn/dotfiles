#!/bin/sh

[[ -e ~/dotfiles ]] || git clone git@github.com:ksmzn/dotfiles.git ~/dotfiles
pushd ~/dotfiles

#git submodule init
#git submodule update

[ -d ~/.config/nvim ] || mkdir ~/.config/nvim

for i in `ls -a`
do
  [ $i = "." ] && continue
  [ $i = ".." ] && continue
  [ $i = ".git" ] && continue
  [ $i = "README.md" ] && continue
  [ $i = "install.sh" ] && continue
  [ $i = ".envrc" ] && continue
  if [[ $i = "peco" ]]; then
    ln -sf ~/dotfiles/$i ~/.config/
  elif [[ $i = "init.vim" ]]; then
    ln -sf ~/dotfiles/$i ~/.config/nvim/
  else
    ln -sf ~/dotfiles/$i ~/
  fi
done

popd
