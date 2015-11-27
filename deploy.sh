#!/bin/bash

VIM_CONF="https://raw.githubusercontent.com/myth/dotlib/master/.vimrc"
ZSH_CONF="https://raw.githubusercontent.com/myth/dotlib/master/.zshrc"
THEME="https://raw.githubusercontent.com/myth/dotlib/master/myth.zsh-theme"

wget -O ~/.vimrc -q "$VIM_CONF"
wget -O ~/.zshrc -q "$ZSH_CONF"
wget -O ~/.oh-my-zsh/themes/myth.zsh-theme -q "$THEME"
