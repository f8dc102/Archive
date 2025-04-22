# Setting Up Development Environment on AWS EC2

## Table of Contents

1. [Introduction](#introduction)
2. [Launch Instance](#launch-instance)
3. [Prevent Unexpected Charges](#prevent-unexpected-charges)

## Introduction

This document provides a step-by-step guide to setting up a development environment on AWS EC2. It includes instructions for launching an instance, configuring cloud-init, and preventing unexpected charges.

## Launch Instance

The setup includes installing essential packages, configuring the shell environment, and setting up auto-stop functionality to save costs.

### cloud-init Configuration

## Prevent Unexpected Charges

If you are using a cloud service like AWS, GCP, or Azure, you may want to stop the instance when you are not using it to prevent unexpected charges.

Automatically stopping the instance when there is no SSH connection for a certain period of time can help you save costs.

### AutoStop Service

This service stops the instance to prevent unexpected charges.

The instance will be stopped if it is running without any ssh connection more than 10 minutes.

#### Installation

Just run the following commands to install the service.

##### Create AutoStop Service

```bash
sudo bash -c 'cat > /etc/systemd/system/autostop.service <<EOF
[Unit]
Description=AutoStop

[Service]
Type=simple
ExecStart=/usr/local/bin/autostop

[Install]
WantedBy=multi-user.target
EOF'
```

##### Create AutoStop Script

```bash
sudo bash -c 'cat > /usr/local/bin/autostop <<EOF
#!/bin/bash

LOGFILE=/var/log/autostop.log

# Reset Counter
counter=0

# Print Start Message
echo "\$(date): Starting Autostop Script." >>\$LOGFILE

# Loop
while true; do
  # Check SSH Connection Established on Port 22
  connections=\$(/usr/bin/ss -tnp | /bin/grep ":22" | /bin/grep ESTAB)

  # If There is No Active Connection, Then
  if [ -z "\$connections" ]; then
    # Increment Counter
    counter=\$((counter + 1))
    echo "\$(date): No SSH Connection. Counter: \$counter" >>\$LOGFILE

    # If The Counter Reaches 10 (10 minutes)
    if [ \$counter -ge 10 ]; then
      echo "\$(date): Counter Reached 10, Poweroff." >>\$LOGFILE
      /usr/sbin/shutdown -h now
      exit
    fi
  else
    # Else, Reset Counter
    counter=0
    echo "\$(date): Active SSH Connection Found, Resetting Counter." >>\$LOGFILE
  fi

  # Wait a minute
  /bin/sleep 60
done
EOF'
```

##### Change Permission and Enable Service

Now, you need to change the permission of the script and enable the service.

```bash
sudo chmod +x /usr/local/bin/autostop
sudo systemctl enable autostop.service
sudo systemctl start autostop.service
sudo systemctl status autostop.service
```

#### Check AutoStop Service Status

After the first run, you can check the status of the service with the following command.

```bash
sudo systemctl status autostop.service
```

You can check the log file `/var/log/autostop.log` to see the status of the service.

```bash
cat /var/log/autostop.log
```

#### Uninstall Autostop Service

If you want to uninstall the service, just run the following commands.

```bash
sudo systemctl stop autostop.service
sudo systemctl disable autostop.service
sudo rm /etc/systemd/system/autostop.service
sudo rm /usr/local/bin/autostop.sh
sudo systemctl daemon-reload
```

## Setup Development Environment

### Cloud-init Configuration

```yaml
#cloud-config
package_update: true
package_upgrade: true

packages:
  - git
  - zsh
  - make
  - cmake
  - tmux
  - curl

system_info:
  default_user:
    name: 22615d7
    shell: /bin/zsh

runcmd:
  - |
    #!/bin/bash
    set -euo pipefail

    USERNAME="22615d7"
    USER_HOME=$(eval echo "~$USERNAME")
    ZSHRC="$USER_HOME/.zshrc"
    OHMYZSH="$USER_HOME/.oh-my-zsh"

    echo "[*] Starting zsh environment setup for $USERNAME..."

    # Oh My Zsh
    if [ ! -d "$OHMYZSH" ]; then
      echo "[*] Installing Oh My Zsh..."
      su - "$USERNAME" -c 'sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || true'
    else
      echo "[*] Oh My Zsh already installed, skipping."
    fi

    # Powerlevel10k
    THEME_DIR="$OHMYZSH/custom/themes/powerlevel10k"
    if [ ! -d "$THEME_DIR" ]; then
      echo "[*] Installing Powerlevel10k theme..."
      su - "$USERNAME" -c "git clone --depth=1 https://github.com/romkatv/powerlevel10k.git '$THEME_DIR'"
    fi

    if ! grep -q 'ZSH_THEME="powerlevel10k/powerlevel10k"' "$ZSHRC"; then
      echo "[*] Setting Powerlevel10k as ZSH_THEME..."
      su - "$USERNAME" -c "sed -i 's|^ZSH_THEME=.*|ZSH_THEME=\"powerlevel10k/powerlevel10k\"|' '$ZSHRC'"
    fi

    # zsh-syntax-highlighting
    SYNTAX_PLUGIN_DIR="$OHMYZSH/custom/plugins/zsh-syntax-highlighting"
    if [ ! -d "$SYNTAX_PLUGIN_DIR" ]; then
      echo "[*] Installing zsh-syntax-highlighting plugin..."
      su - "$USERNAME" -c "git clone https://github.com/zsh-users/zsh-syntax-highlighting.git '$SYNTAX_PLUGIN_DIR'"
    fi

    if ! grep -q 'zsh-syntax-highlighting' "$ZSHRC"; then
      echo "[*] Enabling zsh-syntax-highlighting plugin..."
      su - "$USERNAME" -c "sed -i 's|plugins=(git)|plugins=(git zsh-syntax-highlighting)|' '$ZSHRC'"
    fi

    echo "[*] Fixing permissions..."
    chown -R "$USERNAME:$USERNAME" "$USER_HOME"

    echo "[✓] Zsh environment setup completed successfully."
```

### Add Auto-Stop Service

```bash
sudo bash -c 'cat > /etc/systemd/system/autostop.service <<EOF
[Unit]
Description=AutoStop

[Service]
Type=simple
ExecStart=/usr/local/bin/autostop.sh

[Install]
WantedBy=multi-user.target
EOF'
```

```bash
sudo bash -c 'cat > /usr/local/bin/autostop.sh <<EOF
#!/bin/bash

LOGFILE=/var/log/autostop.log

# Reset Counter
counter=0

# Print Start Message
echo "\$(date): Starting Autostop Script." >>\$LOGFILE

# Loop
while true; do
  # Check SSH Connection Established on Port 22
  connections=\$(/usr/bin/ss -tnp | /bin/grep ":22" | /bin/grep ESTAB)

  # If There is No Active Connection, Then
  if [ -z "\$connections" ]; then
    # Increment Counter
    counter=\$((counter + 1))
    echo "\$(date): No SSH Connection. Counter: \$counter" >>\$LOGFILE

    # If The Counter Reaches 10 (10 minutes)
    if [ \$counter -ge 10 ]; then
      echo "\$(date): Counter Reached 10, Poweroff." >>\$LOGFILE
      /usr/sbin/shutdown -h now
      exit
    fi
  else
    # Else, Reset Counter
    counter=0
    echo "\$(date): Active SSH Connection Found, Resetting Counter." >>\$LOGFILE
  fi

  # Wait a minute
  /bin/sleep 60
done
EOF'
```

```bash
# Change Permission and Enable Service
sudo chmod +x /usr/local/bin/autostop.sh
sudo systemctl enable autostop.service
sudo systemctl start autostop.service

# Check Status
sudo systemctl status autostop.service
```

### Install NeoVim and LazyVim

```bash
# Go to Home Directory and Clone NeoVim
cd && git clone https://github.com/neovim/neovim

# Go to NeoVim Directory and Build
cd neovim && make CMAKE_BUILD_TYPE=RelWithDebInfo

# Install NeoVim
sudo make install

# Clean Up
cd && sudo rm -rf neovim

# Install LazyVim
git clone https://github.com/LazyVim/starter ~/.config/nvim

# Remove Git Directory and Open NeoVim to Install LazyVim
rm -rf ~/.config/nvim/.git && nvim
```

### Install JDK (Corretto 21)

```bash
# To use the Corretto Apt repositories on Debian-based systems, such as Ubuntu, import the Corretto public key and then add the repository to the system list by using the following commands:
wget -O - https://apt.corretto.aws/corretto.key | sudo gpg --dearmor -o /usr/share/keyrings/corretto-keyring.gpg && \
echo "deb [signed-by=/usr/share/keyrings/corretto-keyring.gpg] https://apt.corretto.aws stable main" | sudo tee /etc/apt/sources.list.d/corretto.list

# After the repo has been added, you can install Corretto 23 by running this command:
sudo apt-get update; sudo apt-get install -y java-23-amazon-corretto-jdk
```

### Install Rust and Node.js using nvm

```bash
# Install Rust and Node.js
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash

# Reload Shell
source $HOME/.cargo/env
source ~/.zshrc

# Install Node.js
nvm install 22
```

### Install General Packages

```bash
sudo apt install -y clangd python3.12-full python3-pip php php-cli ruby fish luarocks fd-find golang xsel fzf maven gradle tree
curl -fsSL https://install.julialang.org | sh
```

Maybe useful if you are in arm64 architecture.

```bash
ln -s /usr/bin/clangd ~/.local/share/nvim/mason/bin/clangd
mkdir ~/.local/share/nvim/mason/packages/clangd
```

Install lazygit

```bash
# Download and Install LazyGit
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
# Change the following URL if you are in different architecture.
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_arm64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit -D -t /usr/local/bin/

# Clean Up
rm -rf lazygit*
```

Install NeoVim providers and plugins etc.

```bash
# Install NeoVim Providers
pip3 install neovim --break-system-packages
npm install -g neovim

# Install NeoVim Plugins
pip3 install sqlfluff --break-system-packages
pip3 install tiktoken --break-system-packages
npm install -g tree-sitter-cli
npm install -g markdown-toc
npm install -g markdownlint-cli2
npm install -g prettier
cargo install ripgrep
```

Install PHP Composer

```bash
# Download and Install Composer
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('sha384', 'composer-setup.php') === 'dac665fdc30fdd8ec78b38b9800061b4150413ff2e3b6f88543c636f7cd84f6db9189d43a81e5503cda447da73c7e5b6') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
php -r "unlink('composer-setup.php');"

# Move Composer to bin directory
sudo mv composer.phar /usr/local/bin/composer
```

### Install Docker

```bash
# Set up Docker's apt repository.
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

# Install Docker
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
```

### Reboot

```bash
# To apply all changes, reboot the system.
sudo reboot
```

### Git Configuration

```bash
# Change default branch name to main
git config --global init.defaultBranch main

# Set User Name and Email
git config --global user.name "{name}"
git config --global user.email "{email}"

# Change Editor to NeoVim
git config --global core.editor "nvim"
# Test Editor
git config --global --edit

# Create SSH Key
ssh-keygen -t ed25519 -C "{email}"

# Add SSH Key to SSH Agent
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

# Copy SSH Key And Add to [GitHub](https://github.com/settings/keys)
cat ~/.ssh/id_ed25519.pub
```
