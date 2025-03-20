#!/bin/bash

if [ "$EUID" -ne 0 ]; then
  echo -e "\e[31mPlease run this script as the root user\e[0m"
  exit 1
fi

clear
echo -e "\e[1;34m==============================================\e[0m"
echo -e "\e[1;32m=        🚀 Dria Compute Node Setup 🚀      =\e[0m"
echo -e "\e[1;36m=     📢 https://t.me/KatayanAirdropGnC     =\e[0m"
echo -e "\e[1;33m=                🎯 Batang Eds               =\e[0m"
echo -e "\e[1;34m==============================================\e[0m\n"

WORK_DIR="/root/dria-node"
mkdir -p $WORK_DIR
cd $WORK_DIR

# 1. Stop existing process if running
pkill -f dkn-compute-launcher 2>/dev/null

# 2. Open necessary ports
sudo ufw allow 4001

# 3. Update & install dependencies
apt update && apt upgrade -y
apt install -y git curl build-essential expect

# 4. Install Rust if not installed
if ! command -v rustc &> /dev/null; then
  echo -e "\e[1;32mInstalling Rust...\e[0m"
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  source $HOME/.cargo/env
  rustup update stable
fi

# 5. Install Dria Compute Launcher
echo -e "\e[1;32mInstalling Dria Compute Launcher...\e[0m"
curl -fsSL https://dria.co/launcher | bash
cargo install --git https://github.com/firstbatchxyz/dkn-compute-launcher

# 6. Run Dria Compute Launcher Setup Automatically
echo -e "\e[1;32mConfiguring Dria Compute Node...\e[0m"

expect <<EOF
spawn dkn-compute-launcher start
expect "Provide a secret key of your wallet." 
send -- "YOUR_PRIVATE_KEY_HERE\r"
expect "Select a model provider:"
send -- "gemini\r"
expect "Choose your models with SPACE"
send -- " \r"
send -- " \r"
send -- "\r"
expect "Paste your API KEYS"
send -- "YOUR_API_KEY_HERE\r"
expect "Skip Jina & Serper API key by pressing Enter"
send -- "\r"
expect eof
EOF

echo -e "\e[1;32mDria Compute Node is now running!\e[0m"

# 7. Check logs
echo -e "\e[1;34mCheck logs:\e[0m"
echo -e "\e[1;36m- Dria Compute Node:\e[0m $WORK_DIR/dkn.log"
echo -e "\e[1;33mTo stop the node, use: \e[0m\e[1;31mpkill -f dkn-compute-launcher\e[0m"

