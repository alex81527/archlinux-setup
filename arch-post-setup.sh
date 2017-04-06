package="xorg-server xorg-xinit deepin deepin-screenshot\
	ttf-droid ttf-dejavu ttf-freefont ttf-liberation \
	gcin \
	vlc qt4 libcdio \
	xfce4-terminal \
	zsh git vim rsync openssh most htop cscope \
	chromium curl \
	ethtool traceroute gnu-netcat\
	gimp \
    redshift"


echo 'Packages to be installed:'
echo '================================================================='
echo -e $package
echo '================================================================='

# when SIGINT received, exit directly
sudo pacman -Sy || exit 1
sudo pacman -S --color auto --noconfirm --needed $package

echo '================================================================='
echo 'Fetching .vimrc config file...'
curl -sSL https://raw.githubusercontent.com/alex81527/configs/master/.vimrc -o ~/.vimrc
echo '[~/.vimrc] updated.'

echo 'Fetching .xinitrc config file...'
curl -sSL https://raw.githubusercontent.com/alex81527/configs/master/.xinitrc -o ~/.xinitrc
echo '[~/.xinitrc] updated.'

echo 'Fetching .zshrc config file...'
curl -sSL https://raw.githubusercontent.com/alex81527/configs/master/.zshrc -o ~/.zshrc
echo '[~/.zshrc] updated.'

echo 'Getting cscope plugin for vim...'
mkdir -p ~/.vim/plugin
curl -sSL http://cscope.sourceforge.net/cscope_maps.vim \
    -o ~/.vim/plugin/cscope_maps.vim
echo '[~/.vim/plugin/cscope_maps.vim] updated.'

echo '================================================================='
echo 'You are all set. Enjoy!'
