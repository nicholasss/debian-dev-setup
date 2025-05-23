#!/usr/bin/env bash

set -euo pipefail

# Prompt for user type
read -rp "Is this a (S)erver or (D)esktop setup? " INSTALL_TYPE
INSTALL_TYPE=${INSTALL_TYPE,,} # to lowercase

# Define target user
TARGET_USER="nicholas"

# Sanity check
if ! id "$TARGET_USER" &>/dev/null; then
  echo "Error: User '$TARGET_USER' does not exist."
  exit 1
fi

# Enable bookworm-backports
# echo "=== [Root] Adding bookworm-backports to /etc/apt/sources.list ==="
#
# BACKPORTS_LINE="deb http://deb.debian.org/debian bookworm-backports main contrib non-free non-free-firmware"
# if ! grep -q "^$BACKPORTS_LINE" /etc/apt/sources.list; then
#   echo "$BACKPORTS_LINE" >> /etc/apt/sources.list
#   echo "Backports entry added."
# else
#   echo "Backports entry already present."
# fi

# Updating system
echo "=== [Root] Updating system ==="
apt update && apt upgrade -y

echo "=== [Root] Installing base system packages ==="
apt install -y btop build-essential curl cmake \
  fd-find fish fzf gettext git jq \
  make nano ripgrep tmux unzip vim \
  wget

echo "=== [Root] Installing Neovim via tarball to /usr/local ==="

ARCH=$(uname -m)

case "$ARCH" in
x86_64)
  NVIM_TARBALL="nvim-linux-x86_64.tar.gz"
  EXTRACT_DIR="nvim-linux-x86_64"
  ;;
aarch64 | arm64)
  NVIM_TARBALL="nvim-linux-arm64.tar.gz"
  EXTRACT_DIR="nvim-linux-arm64"
  ;;
*)
  echo "Unsupported architecture: $ARCH"
  exit 1
  ;;
esac

# Download and extract
curl -sL "https://github.com/neovim/neovim/releases/latest/download/$NVIM_TARBALL" |
  tar -xzf - -C /usr/local

# Symlink globally
ln -sf "/usr/local/$EXTRACT_DIR/bin/nvim" /usr/local/bin/nvim

# Optional: verify
command -v nvim && nvim --version | head -n 1

# Server or Desktop specific tasks
case "$INSTALL_TYPE" in
s | server)
  echo "=== [Root] Configuring server-specific packages ==="
  apt install -y fail2ban ufw
  ;;
d | desktop)
  echo "=== [Root] Configuring desktop-specific packages ==="
  apt install -y alacritty neofetch vlc
  ;;
*)
  echo "Invalid input. Please run the script again and choose (S)erver or (D)esktop."
  exit 1
  ;;
esac

# Confirm sudo group
echo "=== [Root] Ensuring $TARGET_USER is in sudo group ==="
usermod -aG sudo "$TARGET_USER"

echo "=== [User] Running user-level provisioning as $TARGET_USER ==="
sudo -u "$TARGET_USER" bash -c '
  set -e

  echo "[User] Setting fish as default shell..."
  chsh -s /usr/bin/fish

  echo "[User] Creating user directories.."
  mkdir -p ~/Developer
  mkdir -p ~/Downloads
  mkdir -p ~/scripts

  echo "[User] Setting up Git config..."
  git config --global init.defaultBranch main
  git config --global user.name "Nicholas"
  git config --global user.email "nicholasss@users.noreply.github.com"
  git config --global alias.aa "add --all"
  git config --global alias.st "status -s -b"
  git config --global alias.cm "commit -m"
  git config --global alias.ll "log --all --decorate --graph --oneline"
  git config --global alias.df "--no-pager diff"

  # Install lazyvim distro
  echo "[User] Installing LazyVim..."
  git clone https://github.com/LazyVim/starter ~/.config/nvim
  rm -rf ~/.config/nvim/.git

  # install webi
  echo "[User] Installing Webi..."
  cd ~/Downloads
  curl -sS https://webi.sh/webi | sh
  source ~/.config/envman/PATH.env

  # install github cli
  echo "[User] Installing GitHub cli..."
  webi gh

  # installing golang 1.24.XX with webi
  echo "[User] Installing Go..."
  webi go@v1.24

  # installing node 22.14 lts
  echo "[User] Installing Node 22 LTS..."
  webi node@22
  
  echo "[User] Installing lazygit..."
  git clone --depth 10 https://github.com/jesseduffield/lazygit.git ~/Downloads/lazygit
  cd ~/Downloads/lazygit
  go install

  # create ~/.bashrc if it does not exist
  echo "[User] Creating ~/.bash_aliases..."
  if [ ! -f "~/.bash_aliases" ]; then
    touch ~/.bash_aliases
  fi

  # TODO: issues with single quotes
  # add aliases
  echo "[User] Modifying ~/.bash_aliases..."
  echo "" >>~/.bash_aliases
  echo "# ADDED BY NONSUDO_SETUP_SCRIPT" >>~/.bash_aliases
  echo "alias ll="ls -lha"" >>~/.bash_aliases
  echo "alias rm="rm -i"" >>~/.bash_aliases
  echo "" >>~/.bash_aliases
  
  # setup case insensitivity
  echo "[User] Modifying ~/.bashrc..."
  echo "" >>~/.bashrc
  echo "# ADDED BY NONSUDO_SETUP_SCRIPT" >>~/.bashrc
  echo "bind -s "set completion-ignore-case on"" >>~/.bashrc
  echo "" >>~/.bashrc

  echo "[User] Setting theme to BreezeDark..."
  plasma-apply-colorscheme BreezeDark

  echo "[User] Done setting up user environment."
'

echo "=== [Done] All setup tasks complete. ==="
