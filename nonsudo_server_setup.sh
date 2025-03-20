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

# git config
git config --global init.defaultBranch main
git config --global user.name "nicholas"
git config --global user.email "nicholasss@users.noreply.github.com"

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
if [ ! -f "~/.bash_aliases" ]; then
  touch ~/.bash_aliases
fi
# add aliases
echo "" >>~/.bash_aliases
echo "# ADDED BY NONSUDO_SETUP_SCRIPT" >>~/.bash_aliases
echo "alias ll='ls -lha'" >>~/.bash_aliases
echo "alias rm='rm -i'" >>~/.bash_aliases
echo "" >>~/.bash_aliases

# setup case insensitivity
echo "" >>~/.bashrc
echo "# ADDED BY NONSUDO_SETUP_SCRIPT" >>~/.bashrc
echo "bind -s 'set completion-ignore-case on'" >>~/.bashrc
echo "" >>~/.bashrc

# finally go to home
cd ~
echo "nonsudo setup complete."
echo "!!! please run 'source ~/.bashrc' in the current terminal."
echo "!!! future terminals will be setup"
