#!/bin/sh

[[ -e ~/dotfiles ]] || git clone git@github.com:ksmzn/dotfiles.git ~/dotfiles
pushd ~/dotfiles

git submodule init
git submodule update

if [ `uname` = "Darwin" ]; then
  pushd ~/dotfiles/.vim/bundle/vimproc
  make -f make_mac.mak
  popd

  ln -s ~/dotfiles/.tmux.conf.osx ~/.tmux.conf
fi

for i in `ls -a`
do
  [ $i = "." ] && continue
  [ $i = ".." ] && continue
  [ $i = ".git" ] && continue
  [ $i = "README.md" ] && continue
  [ $i = "brewfile.sh" ] && continue
  #[ $i = "Brewfile" ] && continue
  [ $i = "install.sh" ] && continue
  if [[ $i = "peco" ]]; then
    ln -sf ~/dotfiles/$i ~/.config/
  else
    ln -sf ~/dotfiles/$i ~/
  fi
done
vim -c ':NeoBundleInstall!' -c ':q!' -c ':q!'
#[ ! -d ~/.vim/bundle ] && mkdir -p ~/.vim/bundle && git clone git://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim && echo "you should run following command to setup plugins ->  vim -c ':NeoBundleInstall'"


popd
