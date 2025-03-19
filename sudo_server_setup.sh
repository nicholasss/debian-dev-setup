#!/bin/bash

# update first and install nala
apt update
apt upgrade -y
apt install nala

# install programs
# neovim may be an older version
nala install btop curl fd-find fzf git jq nano neovim ripgrep tmux
