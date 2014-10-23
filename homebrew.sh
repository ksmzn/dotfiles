#!/bin/sh
if [ `uname` = "Darwin" ]; then
#     java -version
#     xcode-select --install
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
#     brew doctor
#     sh brewfile.sh
fi

