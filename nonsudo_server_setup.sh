#!/bin/bash

# making directories
mkdir ~/Developer
mkdir ~/Downloads
mkdir ~/scripts

# install lazyvim
git clone --depth 10 https://github.com/LazyVim/starter ~/.config/nvim
rm -rf ~/.config/nvim/.git

# add aliases
echo "" >>~/.bashrc
echo "# ADDED BY NONSUDO_SETUP_SCRIPT" >>~/.bashrc
echo "alias ll='ls -lha'" >>~/.bashrc
echo "alias rm='rm -i'" >>~/.bashrc

# install webi
cd ~/Downloads
curl -sS https://webi.sh/webi | sh
source ~/.config/envman/PATH.env

# installing go with webi
cd ~/Downloads
webi go@latest
source ~/.config/envman/PATH.env

# installing lazygit
git clone --depth 10 https://github.com/jesseduffield/lazygit.git ~/Downloads/lazygit
cd ~/Downloads/lazygit
go install

# finally go to home
cd ~
