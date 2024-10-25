#!/bin/bash

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RESET='\033[0m'
BOLD='\033[1m'

# List of required tools
TOOLS=(
    "nmap"
    "rustscan"
    "gobuster"
    "hydra"
    "wfuzz"
    "nikto"
    "wpscan"
    "curl"
    "xargs"
    "jq"
    "python3-pip"
    "bash"
    "echo" #exhausted to complete other tools , in case you had a installation err , go to reddit or stackoverflow am done with this XD
)

# Python packages
PIP_PACKAGES=(
    "requests"
    "beautifulsoup4"
    "base58"
)

get_package_manager() {
    if command -v apt &>/dev/null; then
        echo "apt"
    elif command -v dnf &>/dev/null; then
        echo "dnf"
    elif command -v yum &>/dev/null; then
        echo "yum"
    elif command -v pacman &>/dev/null; then # shout out to best pacman user samyyy
        echo "pacman"
    else
        echo ""
    fi
}

if [ "$EUID" -ne 0 ]; then 
    echo -e "${RED}Please run as root${RESET}"
    exit 1
fi

PKG_MANAGER=$(get_package_manager)
if [ -z "$PKG_MANAGER" ]; then
    echo -e "${RED}No supported package manager found${RESET}"
    exit 1
fi

case $PKG_MANAGER in
    "apt")
        INSTALL_CMD="apt install -y"
        ;;
    "dnf")
        INSTALL_CMD="dnf install -y"
        ;;
    "yum")
        INSTALL_CMD="yum install -y"
        ;;
    "pacman")
        INSTALL_CMD="pacman -S --noconfirm"
        ;;
esac

echo -e "${BLUE}${BOLD}Starting installation of required tools...${RESET}"


echo -e "${YELLOW}Installing required tools...${RESET}"
for tool in "${TOOLS[@]}"; do
    if ! command -v "$tool" &>/dev/null; then
        echo -e "${BLUE}Installing $tool...${RESET}"
        if $INSTALL_CMD "$tool"; then
            echo -e "${GREEN}Successfully installed $tool${RESET}"
        else
            echo -e "${RED}Failed to install $tool${RESET}"
        fi
    else
        echo -e "${GREEN}$tool is already installed${RESET}"
    fi
done

if command -v pip3 &>/dev/null; then
    echo -e "${YELLOW}Installing Python packages...${RESET}"
    for package in "${PIP_PACKAGES[@]}"; do
        echo -e "${BLUE}Installing $package...${RESET}"
        if pip3 install "$package"; then
            echo -e "${GREEN}Successfully installed $package${RESET}"
        else
            echo -e "${RED}Failed to install $package${RESET}"
        fi
    done
fi

# Install Rustscan if not available in package manager
if ! command -v rustscan &>/dev/null; then
    echo -e "${YELLOW}Installing Rustscan...${RESET}"
    if command -v cargo &>/dev/null; then
        cargo install rustscan
    else
        echo -e "${RED}Cargo not found. Installing rust...${RESET}"
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
        source $HOME/.cargo/env
        cargo install rustscan
    fi
fi

# Clone additional tools or repositories if needed
TOOLS_DIR="tools"
if [ ! -d "$TOOLS_DIR" ]; then
    mkdir -p "$TOOLS_DIR"
fi

echo -e "${GREEN}${BOLD}Installation complete!${RESET}"
echo -e "${YELLOW}Note: Some tools might require additional configuration${RESET}"
