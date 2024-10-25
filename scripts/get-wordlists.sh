#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
RESET='\033[0m'
BOLD='\033[1m'

WORDLIST_DIR="./wordlists"
TEMP_DIR="/tmp/wordlists_temp"

setup_directories() {
    echo -e "${BLUE}[*] Setting up directories...${RESET}"
    mkdir -p "$WORDLIST_DIR"/{dns,directories,passwords,usernames,web-content,payloads,custom}
    mkdir -p "$TEMP_DIR"
}

check_requirements() {
    local tools=("wget" "git" "unzip" "tar" "gzip")

    echo -e "${BLUE}[*] Checking requirements...${RESET}"
    for tool in "${tools[@]}"; do
        if ! command -v "$tool" &> /dev/null; then
            echo -e "${RED}[-] $tool is not installed. Installing...${RESET}"
            if command -v apt &> /dev/null; then
                sudo apt update && sudo apt install -y "$tool"
            elif command -v dnf &> /dev/null; then
                sudo dnf install -y "$tool"
            elif command -v yum &> /dev/null; then
                sudo yum install -y "$tool"
            elif command -v pacman &> /dev/null; then
                sudo pacman -Sy --noconfirm "$tool"
            else
                echo -e "${RED}[-] Could not install $tool. Please install it manually.${RESET}"
                exit 1
            fi
        fi
    done
}

download_seclists() {
    echo -e "${BLUE}[*] Downloading SecLists...${RESET}"

    if [ ! -d "$TEMP_DIR/SecLists" ]; then
        git clone --depth 1 https://github.com/danielmiessler/SecLists.git "$TEMP_DIR/SecLists"
    fi

    echo -e "${GREEN}[+] Organizing SecLists files...${RESET}"

    # DNS
    cp "$TEMP_DIR/SecLists/Discovery/DNS/"*.txt "$WORDLIST_DIR/dns/"

    # Directories
    cp "$TEMP_DIR/SecLists/Discovery/Web-Content/"*.txt "$WORDLIST_DIR/directories/"

    # Passwords
    cp "$TEMP_DIR/SecLists/Passwords/Common-Credentials/"*.txt "$WORDLIST_DIR/passwords/"

    # Usernames
    cp "$TEMP_DIR/SecLists/Usernames/"*.txt "$WORDLIST_DIR/usernames/"
}

download_fuzzdb() {
    echo -e "${BLUE}[*] Downloading FuzzDB...${RESET}"

    if [ ! -d "$TEMP_DIR/fuzzdb" ]; then
        git clone --depth 1 https://github.com/fuzzdb-project/fuzzdb.git "$TEMP_DIR/fuzzdb"
    fi

    # Copy relevant files
    echo -e "${GREEN}[+] Organizing FuzzDB files...${RESET}"
    cp -r "$TEMP_DIR/fuzzdb/attack" "$WORDLIST_DIR/payloads/"
    cp -r "$TEMP_DIR/fuzzdb/discovery" "$WORDLIST_DIR/web-content/"
}

download_custom_wordlists() {
    echo -e "${BLUE}[*] Downloading additional wordlists...${RESET}"

    if [ ! -f "$WORDLIST_DIR/passwords/rockyou.txt" ]; then
        echo -e "${YELLOW}[?] Do you want to download the rockyou.txt password list? (y/n)${RESET}"
        read -r response
        if [[ "$response" =~ ^[Yy]$ ]]; then
            wget -c https://github.com/praetorian-inc/Hob0Rules/raw/master/wordlists/rockyou.txt.gz -O "$TEMP_DIR/rockyou.txt.gz"
            gunzip -c "$TEMP_DIR/rockyou.txt.gz" > "$WORDLIST_DIR/passwords/rockyou.txt"
        fi
    fi

    # Common Web Paths
    wget -q https://raw.githubusercontent.com/maurosoria/dirsearch/master/db/dicc.txt -O "$WORDLIST_DIR/directories/dirsearch-common.txt"

    # Common Subdomains
    wget -q https://raw.githubusercontent.com/rbsec/dnscan/master/subdomains.txt -O "$WORDLIST_DIR/dns/common-subdomains.txt"
}

organize_wordlists() {
    echo -e "${BLUE}[*] Organizing and cleaning up...${RESET}"

    find "$WORDLIST_DIR" -type f -name "*.txt" -exec sort -u {} -o {} \;

    cat > "$WORDLIST_DIR/README.md" << EOF
# Wordlists Directory Structure

- dns/: DNS and subdomain wordlists
- directories/: Web directory and file wordlists
- passwords/: Password lists and common credentials
- usernames/: Username lists
- web-content/: Web content discovery lists
- payloads/: Various payload lists for testing
- custom/: Your custom wordlists

Generated on: $(date)
EOF

    # Set permissions
    chmod -R 777 "$WORDLIST_DIR"/*
    chmod 777 "$WORDLIST_DIR"
}

show_stats() {
    echo -e "\n${MAGENTA}[*] Wordlist Statistics:${RESET}"
    echo -e "${CYAN}----------------------------------------${RESET}"
    echo -e "${GREEN}Total Files: $(find "$WORDLIST_DIR" -type f | wc -l)${RESET}"
    echo -e "\n${YELLOW}Files per category:${RESET}"
    for dir in dns directories passwords usernames web-content payloads custom; do
        count=$(find "$WORDLIST_DIR/$dir" -type f | wc -l)
        echo -e "${BLUE}$dir: ${GREEN}$count files${RESET}"
    done
    echo -e "${CYAN}----------------------------------------${RESET}"
}

# Clean up temporary files
cleanup() {
    echo -e "${BLUE}[*] Cleaning up temporary files...${RESET}"
    rm -rf "$TEMP_DIR"
}

main() {
    echo -e "${MAGENTA}╔═══════════════════════════════════╗${RESET}"
    echo -e "${MAGENTA}║    ${CYAN}${BOLD}Sh0zack Wordlist Downloader    ${MAGENTA}║${RESET}"
    echo -e "${MAGENTA}╚═══════════════════════════════════╝${RESET}"
    echo

    check_requirements
    setup_directories

    # Menu
    while true; do
        echo -e "\n${YELLOW}Select wordlists to download:${RESET}"
        echo -e "${GREEN}1. All wordlists (recommended)${RESET}"
        echo -e "${GREEN}2. Only DNS/Subdomain lists${RESET}"
        echo -e "${GREEN}3. Only Directory bruteforce lists${RESET}"
        echo -e "${GREEN}4. Only Password lists${RESET}"
        echo -e "${GREEN}5. Only Custom lists${RESET}"
        echo -e "${RED}6. Exit${RESET}"

        read -p "Enter your choice (1-6): " choice

        case $choice in
            1)
                download_seclists
                download_fuzzdb
                download_custom_wordlists
                break
                ;;
            2)
                cp "$TEMP_DIR/SecLists/Discovery/DNS/"*.txt "$WORDLIST_DIR/dns/"
                break
                ;;
            3)
                cp "$TEMP_DIR/SecLists/Discovery/Web-Content/"*.txt "$WORDLIST_DIR/directories/"
                break
                ;;
            4)
                cp "$TEMP_DIR/SecLists/Passwords/Common-Credentials/"*.txt "$WORDLIST_DIR/passwords/"
                download_custom_wordlists
                break
                ;;
            5)
                download_custom_wordlists
                break
                ;;
            6)
                echo -e "${RED}Exiting...${RESET}"
                exit 0
                ;;
            *)
                echo -e "${RED}Invalid choice. Please try again.${RESET}"
                ;;
        esac
    done

    organize_wordlists
    show_stats
    cleanup

    echo -e "\n${GREEN}[+] Wordlist download and organization complete!${RESET}"
    echo -e "${YELLOW}[*] Wordlists are located in: ${BLUE}$WORDLIST_DIR${RESET}"
}

# Run main function
main

# Error handling
trap 'echo -e "${RED}[-] An error occurred. Cleaning up...${RESET}"; cleanup; exit 1' ERR
