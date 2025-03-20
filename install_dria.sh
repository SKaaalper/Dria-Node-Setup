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
sudo apt install -y curl bash build-essential git

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

# Start a screen session
screen -dmS Dria-Node

# Start Dria Compute Launcher
echo -e "\e[1;32mStarting Dria Compute Node Setup...\e[0m"
dkn-compute-launcher start

# Prompt user to enter necessary information
echo -e "\e[1;32mFollow the prompts to configure your Compute Node\e[0m"
echo -e "\e[1;36m- Use a burner EVM Private Key\e[0m"
echo -e "\e[1;36m- Select models (Recommended: gemini-1.5-flash, gemini-2.0-flash)\e[0m"
echo -e "\e[1;36m- Get API Keys from: https://aistudio.google.com/app/apikey\e[0m"

# Keep the node running in the background
nohup dkn-compute-launcher start > $WORK_DIR/dkn.log 2>&1 &
echo -e "\e[1;32mDria Compute Node is now running in the background 24/7!\e[0m"

# Display log locations
echo -e "\e[1;34mCheck logs:\e[0m"
echo -e "\e[1;36m- Dria Compute Node:\e[0m $WORK_DIR/dkn.log"
echo -e "\e[1;33mTo stop the node, use: \e[0m\e[1;31mpkill -f dkn-compute-launcher\e[0m"
