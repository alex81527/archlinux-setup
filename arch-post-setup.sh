package="xorg-server xorg-xinit deepin deepin-screenshot\
	ttf-droid ttf-dejavu ttf-freefont ttf-liberation \
	gcin \
	vlc qt4 libcdio \
	xfce4-terminal \
	zsh git vim rsync openssh most htop cscope \
	chromium curl \
	ethtool traceroute ifconfig netstat nc route \
	gimp"


echo 'Packages to be installed:'
echo '====================================================='
printf "%s\n" $package
echo '====================================================='
sudo pacman -Sy
sudo pacman -S --color auto --noconfirm --needed $package

echo 'Fetching .vimrc config file...'
curl -sSL https://raw.github.com/alex81527/configs/master/.vimrc -o ~/.vimrc

echo 'Fetching .xinitrc config file...'
curl -sSL https://raw.github.com/alex81527/configs/master/.xinitrc -o ~/.xinitrc

echo 'Fetching .zshrc config file...'
curl -sSL https://raw.github.com/alex81527/configs/master/.zshrc -o ~/.zshrc

echo 'Congratulations! You are all set. Enjoy!'
