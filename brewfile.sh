#!/bin/sh
# HomeBrewを最新版にアップデート
brew update
# Fomulaを更新
brew upgrade

# homebrew-cask設定、インストール
brew tap homebrew/versions
# tap phinze/homebrew-cask
brew tap caskroom/cask
brew tap homebrew/science

# 各種インストール
brew install zsh
brew install git
brew install ctags
brew install mysql
brew install tmux
brew install openssl
brew install cmake
brew install wget
brew install curl
brew install cmake
brew install libtool
brew install automake
brew install tree
brew install tig
brew install hub
brew install gcc
brew install proctool
brew install coreutils
brew install readline

brew install python
brew install python3
brew install ruby
brew install julia
brew install ffmpeg
# Clojure
brew install Leiningen
# Common Lisp
brew install clisp
brew install mit-scheme
# OCaml
brew install ocaml
brew install opam


brew install freetype
brew install fontforge
brew install ricty
brew install nkf
brew install ghostscript
brew install imagemagick

brew tap supermomonga/homebrew-splhack
brew install cscope
brew install lua lua52 luajit
brew install --HEAD ctags-objc-ja
brew install --HEAD cmigemo-mk
brew install macvim-kaoriya --HEAD --with-lua　--with-cscope
brew linkapps

brew cleanup

# 必須アプリ
brew install brew-cask
brew tap caskroom/cask
brew cask install java

brew cask install anki
brew cask install iterm2
brew cask install google-chrome
brew cask insatll google-japanese-ime
brew cask install virtualbox
brew cask install vagrant
brew cask install alfred
brew cask install dropbox
brew cask install evernote
brew cask install xtrafinder
brew cask install yorufukurou
brew cask install keyremap4macbook
brew cask install skitch
brew cask install github
brew cask install lastpass-universal
brew cask install totalspaces2

brew cask install skype
brew cask install startninja
brew cask install bettertouchtool
brew cask install mactex
brew cask install texshop
brew cask install julia-studio

# R
brew brew cask install xquartz
# brew install r
brew brew install r -v --env=std
brew cask install rstudio

brew cask alfred link

brew cask cleanup
