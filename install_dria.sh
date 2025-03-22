#!/bin/bash

if [ "$EUID" -ne 0 ]; then
  echo -e "\e[31mPlease run this script as the root user\e[0m"
  exit 1
fi

clear
echo -e "\e[1;34m==================================================\e[0m"
echo -e "\e[1;32m=        🚀 Dria Compute Node Setup 🚀          =\e[0m"
echo -e "\e[1;36m=     📢 https://t.me/KatayanAirdropGnC         =\e[0m"
echo -e "\e[1;36m=              🧑‍💻 Batang Eds                  =\e[0m"
echo -e "\e[1;34m==================================================\e[0m\n"

WORK_DIR="$HOME/dria-node"
echo -e "\e[1;35mWorking directory:\e[0m $WORK_DIR"

# Create working directory
mkdir -p $WORK_DIR
cd $WORK_DIR

# Open necessary ports
sudo ufw allow 4001

# Update & install dependencies
sudo apt update && sudo apt upgrade -y
sudo apt install -y curl bash build-essential git screen

# Install Rust
if ! command -v rustc &> /dev/null; then
  echo -e "\e[1;32mInstalling Rust...\e[0m"
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  source $HOME/.cargo/env
fi

rustc --version
if [[ $(rustc --version | awk '{print $2}') < "1.78.0" ]]; then
  rustup update stable
fi

# Install Dria Compute Launcher
echo -e "\e[1;32mInstalling Dria Compute Launcher...\e[0m"
curl -fsSL https://dria.co/launcher | bash

# Build from Source
cargo install --git https://github.com/firstbatchxyz/dkn-compute-launcher

# Verify Installation
which dkn-compute-launcher

# Start Dria Compute Launcher inside a screen session
echo -e "\e[1;32mLaunching Dria Compute Node inside a screen session named 'dria'...\e[0m"
screen -dmS dria dkn-compute-launcher start

# Display instructions
echo -e "\e[1;34mScreen session 'dria' started.\e[0m"
echo -e "\e[1;36mTo view logs:\e[0m \e[1;33mscreen -r dria\e[0m"
echo -e "\e[1;36mTo detach:\e[0m \e[1;33mCtrl+A then D\e[0m"
echo -e "\e[1;36mTo stop the node:\e[0m \e[1;31mpkill -f dkn-compute-launcher\e[0m"
