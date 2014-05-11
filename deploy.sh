#!/bin/bash

VIM_CONF="https://raw.githubusercontent.com/mythern/dotlib/master/.vimrc"
ZSH_CONF="https://raw.githubusercontent.com/mythern/dotlib/master/.zshrc"

wget -O ~/.vimrc -q "$VIM_CONF"
wget -O ~/.zshrc -q "$ZSH_CONF"

