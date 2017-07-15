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
DOCK="plank"
INTEL_MICROCODE="intel-ucode"
# ttf-droid has a wide coverage of character set for different languages.

# ttf-liberation has a great looking on terminal.
# Liberation Sans, Liberation Sans Narrow and Liberation Serif closely match 
# the metrics of Monotype Corporation fonts Arial, Arial Narrow and 
# Times New Roman, respectively.
FONTS="ttf-droid ttf-liberation ttf-ms-fonts"
IM="gcin"
MULTIMEDIA="vlc qt4 libcdio ffmpeg"
SHELL="zsh"
# In order to use system buffer, we need the +clipboard feature, which is 
# missing in vim.
EDITOR="gvim"
PAGER="most"
BROWSER="chromium"
# networkmanager uses dhclient as dhcp client by default
NET_TOOLS="rsync openssh curl wget ethtool traceroute gnu-netcat iperf iperf3 \
networkmanager dhclient wireshark-qt tcpdump nload iw wpa_supplicant nemesis \
mosh"
GIT="git"
COMPILER="clang"
CODE_TRACING="ctags cscope ack"
# clang-format is included in package <clang>
CODE_FORMATTER="yapf"
IMAGE_CROP="pinta"
TEX_SUITE="texlive-most texstudio jabref"
PLOT="gnuplot"
PYTHON="python python2 python2-virtualenv python-pip python2-pip"
LINTER="flake8 shellcheck"
DEBUG="gdb valgrind ltrace strace"
POWER_SAVING="tlp"
# PDF="foxitreader"
KERNEL="linux-zen"
# GRUB is the bootloader, efibootmgr creates bootable .efi stub entries used by 
# the GRUB installation script.
BOOTLOADER="grub efibootmgr os-prober"
# xss-lock subscribes to the systemd-events suspend, hibernate, lock-session, 
# and unlock-session with appropriate actions using external screen lockers.

# physlock: screen and console locker

# snort: Network IDS
# OSSEC: Host-based IDS
SECURITY="xss-lock-git physlock sshguard"
TMUX="tmux"
SPOTIFY="spotify"
OFFICE="libreoffice-still"
OTHER="htop screenfetch redshift"
PACKAGE="$DE $DOCK $INTEL_MICROCODE $FONTS $IM $MULTIMEDIA $SHELL $EDITOR \
$PAGER $BROWSER $NET_TOOLS $GIT $COMPILER $CODE_TRACING $CODE_FORMATTER \
$IMAGE_CROP $TEX_SUITE $PLOT $PYTHON $LINTER $DEBUG $POWER_SAVING $KERNEL \
$BOOTLOADER $SECURITY $TMUX $SPOTIFY $OFFICE $OTHER"

echo '================================================================='
echo 'Install Arch Packages'
echo -e "$PACKAGE"
echo '================================================================='


# when SIGINT received, exit directly
yaourt -Syy --color || exit 1

# Double quotes for $PACKAGE is purposedly taken out
yaourt -S --noconfirm --needed --color $PACKAGE


############################Package Configuration###############################
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

# Prevent root login for ssh
sudo sed -i -e 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config
# Enable sshguard
sudo iptables -N sshguard
sudo iptables -A INPUT -p tcp --dport 22 -j sshguard
iptables-save | sudo tee iptables.rules
sudo cp iptables.rules /etc/iptables/
rm -f iptables.rules
sudo systemctl enable sshguard.service

# Enable iptables
sudo systemctl enable iptables.service

# Setup powerline for tmux
#mkdir -p ~/github && cd ~/github
#git clone https://github.com/powerline/powerline.git
#cd ~
#sudo pip install powerline-status

# Setup background wallpaper
wallpaper="taipei101.jpg"
curl -sSL \
https://raw.githubusercontent.com/alex81527/archlinux-setup/master/wallpaper/\
$wallpaper > ~/Pictures/$wallpaper
gsettings set org.gnome.desktop.background picture-uri ~/Pictures/$wallpaper
# Setup screensaver wallpaper
#curl -sSL \
#https://raw.githubusercontent.com/alex81527/archlinux-setup/master/wallpaper/\
#archlinux.png > ~/Pictures/archlinux.png
#gsettings set org.gnome.desktop.screensaver picture-uri ~/Pictures/archlinux.png

################################################################################

echo '================================================================='
echo 'Download configuration files:'
echo 'Fetching .xinitrc config file...'
curl -sSL https://raw.githubusercontent.com/alex81527/configs/master/dotfiles/.xinitrc \
    -o ~/.xinitrc
echo '[~/.xinitrc] updated.'


echo 'Fetching .tmux.conf config file...'
curl -sSL https://raw.githubusercontent.com/alex81527/configs/master/dotfiles/.tmux.conf\
    -o ~/.tmux.conf
echo '[~/.tmux.conf] updated.'

echo 'Setting up oh-my-zsh...'
sh -c "$(curl -fsSL \
https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
echo 'Fetching .zshrc config file...'
curl -sSL https://raw.githubusercontent.com/alex81527/configs/master/dotfiles/.zshrc \
    -o ~/.zshrc
echo '[~/.zshrc] updated.'


echo 'Fetching .zprofile config file...'
curl -sSL https://raw.githubusercontent.com/alex81527/configs/master/dotfiles/.zprofile \
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
