#!/bin/sh

BASE_URL="https://raw.githubusercontent.com/myth/dotlib/master"
VIM_CONF="$BASE_URL/.vimrc"
ZSH_CONF="$BASE_URL/.zshrc"
THEME="$BASE_URL/myth.zsh-theme"
ALIASES="$BASE_URL/aliases"

wget -O ~/.vimrc -q "$VIM_CONF"
wget -O ~/.zshrc -q "$ZSH_CONF"
wget -O ~/.oh-my-zsh/themes/myth.zsh-theme -q "$THEME"

mkdir -p ~/.profile.d

wget -O ~/.profile.d/aliases -q "$ALIASES"
touch ~/.profile.d/default
