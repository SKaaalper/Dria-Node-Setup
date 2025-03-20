#!/bin/bash

if [ "$EUID" -ne 0 ]; then
  echo -e "\e[31mPlease run this script as the root user\e[0m"
  exit 1
fi

clear
echo -e "\e[1;34m==================================================\e[0m"
echo -e "\e[1;32m=        🚀 Dria Compute Node Setup 🚀          =\e[0m"
echo -e "\e[1;36m=     📢 https://t.me/KatayanAirdropGnC         =\e[0m"
echo -e "\e[1;34m==================================================\e[0m\n"

WORK_DIR="/root/dria-node"
echo -e "\e[1;35mWorking directory:\e[0m $WORK_DIR"

# 1. Create working directory
mkdir -p $WORK_DIR
cd $WORK_DIR

# 2. Open necessary ports
sudo ufw allow 4001

# 3. Update & install dependencies
apt update && apt upgrade -y
apt install -y git curl build-essential

# 4. Install Rust
if ! command -v rustc &> /dev/null; then
  echo -e "\e[1;32mInstalling Rust...\e[0m"
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  source $HOME/.cargo/env
  rustc --version
  rustup update stable
fi

# 5. Install Dria Compute Launcher
echo -e "\e[1;32mInstalling Dria Compute Launcher...\e[0m"
curl -fsSL https://dria.co/launcher | bash

# 6. Start Dria Compute Launcher (background process)
echo -e "\e[1;32mStarting Dria Compute Node Setup...\e[0m"
nohup dkn-compute-launcher start > $WORK_DIR/dkn_setup.log 2>&1 &

# 7. Wait for Dria Compute Launcher to initialize
sleep 10

# 8. Prompt user to enter their private key and API key
read -p "Enter your Wallet Private Key: " WALLET_PRIVATE_KEY
read -p "Enter your API Key: " API_KEY

# 9. Configure Compute Node
echo -e "\e[1;32mConfiguring Compute Node...\e[0m"
echo "$WALLET_PRIVATE_KEY" | dkn-compute-launcher set-key
echo "$API_KEY" | dkn-compute-launcher set-api-key

# 10. Restart and run Dria Compute Node in the background
nohup dkn-compute-launcher start > $WORK_DIR/dkn.log 2>&1 &

echo -e "\e[1;32mDria Compute Node is now running in the background!\e[0m"

# 11. Display log locations
echo -e "\e[1;34mCheck logs:\e[0m"
echo -e "\e[1;36m- Dria Compute Node:\e[0m $WORK_DIR/dkn.log"
echo -e "\e[1;33mTo stop the node, use: \e[0m\e[1;31mpkill -f dkn-compute-launcher\e[0m"

