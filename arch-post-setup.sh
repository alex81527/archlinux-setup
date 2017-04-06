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
echo '====================================================='
printf "%s\n" $package
echo '====================================================='
sudo pacman -Sy
sudo pacman -S --color auto --noconfirm --needed $package

echo '====================================================='
echo 'Fetching .vimrc config file...'
curl -sSL https://raw.github.com/alex81527/configs/master/.vimrc -o ~/.vimrc

echo 'Fetching .xinitrc config file...'
curl -sSL https://raw.github.com/alex81527/configs/master/.xinitrc -o ~/.xinitrc

echo 'Fetching .zshrc config file...'
curl -sSL https://raw.github.com/alex81527/configs/master/.zshrc -o ~/.zshrc

echo 'Getting cscope plugin for vim...'
mkdir -p ~/.vim/plugin
curl -sSL http://cscope.sourceforge.net/cscope_maps.vim \
    -o ~/.vim/plugin/cscope_maps.vim

echo '====================================================='
echo 'You are all set. Enjoy!'
