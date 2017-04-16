#!/usr/bin/env bash

# Although deepin is fancy-looking, it is a bit buggy.
# Use GNOME instead for stability.
DE="xorg-server xorg-xinit gnome"
INTEL_MICROCODE="intel-ucode"
FONTS="ttf-droid ttf-dejavu ttf-freefont ttf-liberation"
IM="gcin"
VIDEO_PLAYER="vlc qt4 libcdio"
SHELL="zsh"
EDITOR="vim"
PAGER="most"
BROWSER="chromium"
NET_TOOLS="rsync openssh curl ethtool traceroute gnu-netcat iperf iperf3 networkmanager"
VER_CONTROL="git"
CODE_TRACE="cscope ack"
PHOTO_EDIT="gimp"
TEX="texlive-most texstudio"
PLOT="gnuplot"
PYTHON="python python2 python2-virtualenv python-pip python2-pip"
LINTER="python-pylint python2-pylint shellcheck"
DEBUGGER="gdb"
OTHER="htop screenfetch redshift"
PACKAGE="$DE $INTEL_MICROCODE $FONTS $IM $VIDEO_PLAYER $SHELL $EDITOR $PAGER 
         $BROWSER $NET_TOOLS $VER_CONTROL $CODE_TRACE $PHOTO_EDIT $TEX $PLOT 
         $PYTHON $LINTER $DEBUGGER $OTHER"

echo 'Packages to be installed:'
echo '================================================================='
echo -e "$PACKAGE"
echo '================================================================='

# when SIGINT received, exit directly
sudo pacman -Sy || exit 1
# Double quotes for $PACKAGE is purposedly taken out
sudo pacman -S --color auto --noconfirm --needed $PACKAGE


echo -e '\n\nInstalling AUR Packages'
echo '================================================================='
echo 'yEd foxitreader'
echo '================================================================='
#AUR packages
mkdir -p ~/AUR_PKG 
# yEd
cd ~/AUR_PKG && git clone https://aur.archlinux.org/yed.git 
cd ~/AUR_PKG/yed && makepkg -cis --needed --noconfirm 
# foxitreader
cd ~/AUR_PKG && git clone https://aur.archlinux.org/foxitreader.git
cd ~/AUR_PKG && git clone https://aur.archlinux.org/qt-installer-framework.git
cd ~/AUR_PKG/qt-installer-framework && makepkg -cis --needed --noconfirm 
cd ~/AUR_PKG/foxitreader && makepkg -cis --needed --noconfirm 

# Enable Networkmanager to start at boot
sudo systemctl enable NetworkManager.service

echo -e '\n\nDownload configuration files:'
echo '================================================================='
echo 'Fetching .xinitrc config file...'
curl -sSL https://raw.githubusercontent.com/alex81527/configs/master/.xinitrc \
    -o ~/.xinitrc
echo '[~/.xinitrc] updated.'

echo 'Setting up oh-my-zsh...'
sh -c "$(curl -fsSL \
https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
echo 'Fetching .zshrc config file...'
curl -sSL https://raw.githubusercontent.com/alex81527/configs/master/.zshrc \
    -o ~/.zshrc
echo '[~/.zshrc] updated.'

echo 'Installing vim plugins...'
bash -c "$(curl -sSL \
https://raw.githubusercontent.com/alex81527/configs/master/vim-setup.sh)"

echo 'Adding git config --global'
echo -n "Configure git user.name (default = W. Alex Chen):"
read name
echo -n "Configure git user.email (default = alex81527@gmail.com):"
read email
echo -n "Configure git core.editor (default = vim):"
read editor

if [ -z "$name" ]; then
    name="W. Alex Chen"
fi

if [ -z "$email" ]; then
    email="alex81527@gmail.com"
fi

if [ -z "$editor" ]; then
    editor="vim"
fi

git config --global user.name "$name"
git config --global user.email "$email"
git config --global core.editor "$editor"

echo '[~/.gitconfig] updated.'
cat ~/.gitconfig

echo 'Cleaning up...'
# Get rid of shitty packages from gnome
sudo pacman -R evince totem epiphany --noconfirm 
rm -rf ~/AUR_PKG
echo '================================================================='

echo 'You are all set. Reboot in 5 sec...'
#sleep 5
#systemctl reboot
