#!/bin/bash

# making directories
if [ ! -d "~/Developer" ]; then
  mkdir ~/Developer
fi

if [ ! -d "~/Downloads" ]; then
  mkdir ~/Downloads
fi

if [ ! -d "~/scripts" ]; then
  mkdir ~/scripts
fi

# installing lazygit
# used for lazyvim
cd ~/Downloads
git clone --depth 10 https://github.com/jesseduffield/lazygit.git ~/Downloads/lazygit
cd ~/Downloads/lazygit
go install

# install lazyvim distro
git clone --depth 10 https://github.com/LazyVim/starter ~/.config/nvim
rm -rf ~/.config/nvim/.git

# install webi
cd ~/Downloads
curl -sS https://webi.sh/webi | sh
source ~/.config/envman/PATH.env

# installing golang 1.24.XX with webi
# webi does not need a specific directory
webi go@v1.24
source ~/.config/envman/PATH.env

# installing node 22.14 lts
webi node@22
source ~/.config/envman/PATH.env

# create ~/.bashrc if it does not exist
if [ ! -f "~/.bashrc" ]; then
  touch ~/.bashrc
fi
# add aliases
echo "" >>~/.bashrc
echo "# ADDED BY NONSUDO_SETUP_SCRIPT" >>~/.bashrc
echo "alias ll='ls -lha'" >>~/.bashrc
echo "alias rm='rm -i'" >>~/.bashrc
echo "" >>~/.bashrc
echo "bind -s 'set completion-ignore-case on'" >>~/.bashrc
echo "" >>~/.bashrc
source ~/.bashrc

# finally go to home
cd ~
echo "nonsudo setup complete."
