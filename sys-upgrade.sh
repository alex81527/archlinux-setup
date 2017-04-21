sudo reflector --verbose --latest 10 --sort rate --country TW \
    --save /etc/pacman.d/mirrorlist
sudo pacman -Syu
vim +PluginUpdate +qall
sh ~/.oh-my-zsh/tools/upgrade.sh
