DE="xorg-server xorg-xinit deepin deepin-screenshot "
INTEL_MICROCODE="intel-ucode "
FONTS="ttf-droid ttf-dejavu ttf-freefont ttf-liberation "
IM="gcin "
VIDEO_PLAYER="vlc qt4 libcdio "
TERMINAL="xfce4-terminal "
SHELL="zsh "
EDITOR="vim "
PAGER="most "
BROWSER="chromium "
NET_TOOLS="rsync openssh curl ethtool traceroute gnu-netcat "
VER_CONTROL="git "
CODE_TRACE="cscope ack "
PHOTO_EDIT="gimp "
OTHER="htop screenfetch redshift "
PACKAGE="$DE $INTEL_MICROCODE $FONTS $IM $VIDEO_PLAYER $TERMINAL \
         $SHELL $EDITOR $PAGER $BROWSER $NET_TOOLS $VER_CONTROL \
         $CODE_TRACE $PHOTO_EDIT $OTHER"

echo 'Packages to be installed:'
echo '================================================================='
echo -e $PACKAGE
echo '================================================================='

# when SIGINT received, exit directly
sudo pacman -Sy || exit 1
sudo pacman -S --color auto --noconfirm --needed $PACKAGE

echo '================================================================='
echo 'Fetching .vimrc config file...'
curl -sSL https://raw.githubusercontent.com/alex81527/configs/master/.vimrc \
    -o ~/.vimrc
echo '[~/.vimrc] updated.'

echo 'Fetching .xinitrc config file...'
curl -sSL https://raw.githubusercontent.com/alex81527/configs/master/.xinitrc \
    -o ~/.xinitrc
echo '[~/.xinitrc] updated.'

echo 'Fetching .zshrc config file...'
curl -sSL https://raw.githubusercontent.com/alex81527/configs/master/.zshrc \
    -o ~/.zshrc
echo '[~/.zshrc] updated.'

echo 'Getting cscope plugin for vim...'
mkdir -p ~/.vim/plugin
curl -sSL http://cscope.sourceforge.net/cscope_maps.vim \
    -o ~/.vim/plugin/cscope_maps.vim
echo '[~/.vim/plugin/cscope_maps.vim] updated.'

echo '================================================================='
echo 'You are all set. Enjoy!'
