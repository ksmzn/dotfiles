#!/bin/sh

[[ -e ~/dotfiles ]] || git clone git@github.com:ksmzn/dotfiles.git ~/dotfiles
pushd ~/dotfiles

#git submodule init
#git submodule update

for i in `ls -a`
do
  [ $i = "." ] && continue
  [ $i = ".." ] && continue
  [ $i = ".git" ] && continue
  [ $i = "README.md" ] && continue
  [ $i = "install.sh" ] && continue
  if [[ $i = "peco" ]]; then
    ln -sf ~/dotfiles/$i ~/.config/
  else
    ln -sf ~/dotfiles/$i ~/
  fi
done

popd
