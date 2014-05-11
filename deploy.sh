#! /bin/bash

VIM_CONF = "https://raw.githubusercontent.com/mythern/dotlib/master/.vimrc"
ZSH_CONF = "https://raw.githubusercontent.com/mythern/dotlib/master/.zshrc"

wget -O ~/.vimrc $VIM_CONF
wget -O ~/.zshrc $ZSH_CONF

