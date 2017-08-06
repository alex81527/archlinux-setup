#!/usr/bin/env sh
sudo reflector --verbose --latest 10 --sort rate --country TW \
    --save /etc/pacman.d/mirrorlist
yaourt -Syu -a 
vim +PluginUpdate +qall
sh ~/.oh-my-zsh/tools/upgrade.sh
