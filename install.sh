#! /usr/bin/bash

# install env
WORK_DIR=$HOME
# move into work directory
mkdir -p ${WORK_DIR}
cd ${WORK_DIR}
# download neccessary package and software
apt-get update -y
# basic dependency software
apt-get install gcc git ncurses-dev make python2-dev python3-dev -y


# ===
# === golang env
# ===


# ===
# === cowsay
# ===
apt-get install cowsay -y


# ===
# === ranger
# ===
apt-get install ranger -y


# ===
# === lazygit
# ===
add-apt-repository ppa:lazygit-team/release
apt-get update -y
apt-get install lazygit -y
# config color highlight
cat << EOF > ~/.config/jesseduffield/lazygit/config.yml
startuppopupversion: 1
gui:
  theme:
    selectedLineBgColor:
      - reverse
    selectedRangeBgColor:
      - reverse
EOF


# ===
# === ripgrep
# ===
# ripgrep, supprt search feature
curl -LO https://github.com/BurntSushi/ripgrep/releases/download/11.0.2/ripgrep_11.0.2_amd64.deb
sudo dpkg -i ripgrep_11.0.2_amd64.deb


# ===
# === nodejs
# ===
# intall nodejs, coc-nvim dependency
curl -sL install-node.now.sh/lts > install_nodejs.sh
yes | bash install_nodejs.sh
rm install_nodejs.sh


# ===
# === vim
# ===
# install the latest vim
echo | sudo add-apt-repository ppa:jonathonf/vim
sudo apt-get update -y
sudo apt-get install vim -y
# my vim config
git clone https://github.com/KMFtcy/.myvim.git
# replace old vimrc
if [ -f "~/.vimrc" ]; then
    mv  ~/.vimrc ~/.vimrc.previous
fi
ln -s $basepath/vimrc ~/.vimrc
# install vim-plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
# install vim plugins
vim -c PlugInstall -c q -c q
