# https://bsdbox.de/artikel/tipps/freebsd-zsh
pkg install -y zsh ohmyzsh
cp /usr/local/share/ohmyzsh/templates/zshrc.zsh-template ~/.zshrc
chsh -s zsh
# su -l USERNAME -c 'cp /usr/local/share/ohmyzsh/templates/zshrc.zsh-template ~/.zshrc'
# chsh -s zsh USERNAME
zsh
