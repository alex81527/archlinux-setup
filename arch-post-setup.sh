#!/usr/bin/env bash

# Enable 32bit official repository [multilib]
sudo sed -i.backup -e '/#\[multilib\]/,+2 s/[#]//' /etc/pacman.conf

# Update mirrorlist first
sudo pacman -S --color auto --noconfirm --needed reflector
reflector --list-countries
echo "============================Config==============================="
echo -n "Enter your country code: "
read -r country
echo -n "Configure git user.name (default = W. Alex Chen):"
read -r name
echo -n "Configure git user.email (default = alex81527@gmail.com):"
read -r email
echo -n "Configure git core.editor (default = vim):"
read -r editor
echo "================================================================="

sudo cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
sudo reflector --verbose --latest 10 --sort rate --country  "$country"\
    --save /etc/pacman.d/mirrorlist

# Install AUR helper: yaourt
# The if section is added for testing reason
if [ -n "`env yaourt 2>&1 | grep 'No such file or directory'`" ]; then
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
networkmanager wireshark-qt nload"
VER_CONTROL="git"
CODE_TRACE="cscope ack"
PHOTO_EDIT="gimp"
TEX_SUITE="texlive-most texstudio jabref"
PLOT="gnuplot"
PYTHON="python python2 python2-virtualenv python-pip python2-pip"
LINTER="python-pylint python2-pylint shellcheck"
DEBUGGER="gdb"
POWER_SAVING="tlp"
PDF="foxitreader"
OTHER="htop screenfetch redshift"
PACKAGE="$DE $DOCK $INTEL_MICROCODE $FONTS $IM $VIDEO_PLAYER $SHELL $EDITOR \
$PAGER $BROWSER $NET_TOOLS $VER_CONTROL $CODE_TRACE $PHOTO_EDIT $TEX_SUITE \
$PLOT $PYTHON $LINTER $DEBUGGER $POWER_SAVING $PDF $OTHER"

echo '================================================================='
echo 'Install Arch Packages'
echo -e "$PACKAGE"
echo '================================================================='


# when SIGINT received, exit directly
yaourt -Syy || exit 1
# Double quotes for $PACKAGE is purposedly taken out
yaourt -S --noconfirm --needed $PACKAGE

# Run Networkmanager at bootup
sudo systemctl enable NetworkManager.service

# Add user to wireshark group
sudo gpasswd -a "$USER" wireshark

# Enable tlp 
sudo systemctl enable tlp.service
sudo systemctl enable tlp-sleep.service
sudo systemctl mask systemd-rfkill.service

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

echo '[~/.gitconfig] updated.'
cat ~/.gitconfig

echo 'Cleaning up...'
# Get rid of shitty packages from gnome
# epiphany: browser, totem: video player
yaourt -Rs --noconfirm totem epiphany  
rm -rf ~/AUR
echo '================================================================='

screenfetch
sudo tlp-stat -p 
echo 'You should modify /etc/default/tlp to your need by yourself.'
echo 'Reboot to apply all changes.'
