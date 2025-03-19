#!/bin/bash

# update first and install nala
apt update
apt upgrade -y
apt install nala

# install programs
# lazygit not found in debian
nala install btop curl fd-find fzf git jq nano neofetch ripgrep tmux
