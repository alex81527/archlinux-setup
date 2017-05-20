#!/usr/bin/env bash

echo "======================Configuration=============================="
echo -n "Enter your country code (TW/US/DE/FR/CA/JP/HK/...): "
read -r country
echo -n "Configure git user.name (default = W. Alex Chen):"
read -r name
echo -n "Configure git user.email (default = alex81527@gmail.com):"
read -r email
echo -n "Configure git core.editor (default = vim):"
read -r editor
echo "================================================================="

# Update mirrorlist first
sudo pacman -S --color auto --noconfirm --needed reflector
#reflector --list-countries
sudo cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
sudo reflector --verbose --latest 10 --sort rate --country  "$country"\
    --save /etc/pacman.d/mirrorlist

# Enable 32bit official repository [multilib]
sudo sed -i.backup -e '/#\[multilib\]/,+2 s/[#]//' /etc/pacman.conf

# Install AUR helper: yaourt
# The if section is added for testing reason
if [ -n "$(env yaourt 2>&1 | grep 'No such file or directory')" ]; then
    mkdir ~/AUR && (cd ~/AUR || exit)
    git clone https://aur.archlinux.org/package-query.git
    cd package-query || exit 
    makepkg -cis --noconfirm
    cd .. 
    git clone https://aur.archlinux.org/yaourt.git
    cd yaourt || exit 
    makepkg -cis --noconfirm
    cd ~ || exit
    rm -rf AUR
fi

# Although deepin is fancy-looking, it is a bit buggy.
# Use GNOME instead for stability.
DE="xorg-server xorg-xinit gnome"
DOCK="cairo-dock cairo-dock-plug-ins"
INTEL_MICROCODE="intel-ucode"
# ttf-droid has a wide coverage of character set for different languages.

# ttf-liberation has a great looking on terminal.
# Liberation Sans, Liberation Sans Narrow and Liberation Serif closely match 
# the metrics of Monotype Corporation fonts Arial, Arial Narrow and 
# Times New Roman, respectively.
FONTS="ttf-droid ttf-liberation ttf-ms-fonts"
IM="gcin"
VIDEO_PLAYER="vlc qt4 libcdio"
SHELL="zsh"
EDITOR="vim"
PAGER="most"
BROWSER="chromium"
NET_TOOLS="rsync openssh curl ethtool traceroute gnu-netcat iperf iperf3 \
networkmanager wireshark-qt nload iw wpa_supplicant"
VER_CONTROL="git"
CODE_TRACE="cscope ack"
PHOTO_EDIT="gimp"
TEX_SUITE="texlive-most texstudio jabref"
PLOT="gnuplot"
PYTHON="python python2 python2-virtualenv python-pip python2-pip"
LINTER="python-pylint python2-pylint shellcheck"
DEBUG="gdb valgrind ltrace strace"
POWER_SAVING="tlp"
PDF="foxitreader"
KERNEL="linux-zen"
# GRUB is the bootloader, efibootmgr creates bootable .efi stub entries used by 
# the GRUB installation script.
BOOTLOADER="grub efibootmgr os-prober"
OTHER="htop screenfetch redshift"
PACKAGE="$DE $DOCK $INTEL_MICROCODE $FONTS $IM $VIDEO_PLAYER $SHELL $EDITOR \
$PAGER $BROWSER $NET_TOOLS $VER_CONTROL $CODE_TRACE $PHOTO_EDIT $TEX_SUITE \
$PLOT $PYTHON $LINTER $DEBUG $POWER_SAVING $PDF $KERNEL $BOOTLOADER $OTHER"

echo '================================================================='
echo 'Install Arch Packages'
echo -e "$PACKAGE"
echo '================================================================='


# when SIGINT received, exit directly
yaourt -Syy --color || exit 1
# Double quotes for $PACKAGE is purposedly taken out
yaourt -S --noconfirm --needed --color $PACKAGE

# Run Networkmanager at bootup
sudo systemctl enable NetworkManager.service

# Add user to wireshark group
sudo gpasswd -a "$USER" wireshark

# Enable tlp 
sudo systemctl enable tlp.service
sudo systemctl enable tlp-sleep.service
sudo systemctl mask systemd-rfkill.service

# Regenerate /boot/grub/grub.cfg to include linux-zen
# TODO: grub-set-default X, X is the menuentry number
sudo grub-mkconfig -o /boot/grub/grub.cfg

echo '================================================================='
echo 'Download configuration files:'
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


echo 'Fetching .zprofile config file...'
curl -sSL https://raw.githubusercontent.com/alex81527/configs/master/.zprofile \
    -o ~/.zprofile
echo '[~/.zprofile] updated.'


echo 'Installing vim plugins...'
sh -c "$(curl -sSL \
https://raw.githubusercontent.com/alex81527/configs/master/vim-setup.sh)"

echo 'Adding git config --global'
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

echo -e '[~/.gitconfig] updated.\n'
cat ~/.gitconfig

# Get rid of shitty packages from gnome
# epiphany: browser, totem: video player
#yaourt -Rs --noconfirm --color totem epiphany  
echo '================================================================='

sudo tlp-stat  

screenfetch
echo 'Reboot to apply all changes.'
