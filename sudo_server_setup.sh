#!/bin/bash

# update first and install nala
apt update
apt upgrade -y
apt install nala

# install tools and dependencies
nala install btop build-essential curl cmake fd-find fzf gettext git jq make nano ninja-build ripgrep tmux unzip xclip

# installing neovim
cd /home/nicholas/Downloads
git clone https://github.com/neovim/neovim /home/nicholas/Downloads/neovim
cd /home/nicholas/Downloads/neovim
git checkout stable

# for specific tag
# git fetch --all --tags
# git checkout v0.10.4

make CMAKE_BUILD_TYPE=RelWithDebInfo
cd /home/nicholas/Downloads/neovim/build
cpack -G DEB                  # sudo
dpkg -i nvim-linux-x86_64.deb # sudo
