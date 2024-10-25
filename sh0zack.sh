#!/bin/bash
# les couleurs ya chi5
PROMPT="sh0zack >"
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
RESET='\033[0m'
BOLD='\033[1m'
NORMAL='\033[0m'
cmd_ulach() {
    if ! command -v "$1" &> /dev/null; then
        echo -e "${BOLD}${RED}Error: $1 command not found. Please install it.${RESET}"
#         echo -e $(apt search $1 ||  snap search $1) # if u wanna expose availbale ones
        local sudochk=$(sudo -n true 2>&1)
        if [ "$?" -ne 0 ]; then
            echo -e "${RED}You need to have sudo privileges to install packages.${RESET}"
            return 1
        fi
        if command -v apt &>/dev/null; then
            PKG_MANAGER="apt"
            INSTALL_CMD="apt install -y"
        elif command -v dnf &>/dev/null; then
            PKG_MANAGER="dnf"
            INSTALL_CMD="dnf install -y"
        elif command -v yum &>/dev/null; then
            PKG_MANAGER="yum"
            INSTALL_CMD="yum install -y"
        elif command -v pacman &>/dev/null; then
            PKG_MANAGER="pacman"
            INSTALL_CMD="pacman -S --noconfirm"
        else
            echo -e "${RED}No supported package manager found.${RESET}"
            return 1
        fi

        read -p "Do you want to install $1? (y/n): " install
        if [ "$install" = "y" ]; then
            echo -e "${GREEN}Installing $1...${RESET}"
            if sudo $INSTALL_CMD "$1"; then
                echo -e "${GREEN}Successfully installed $1${RESET}"
                return 0
            else
                echo -e "${RED}Failed to install $1${RESET}"
                return 1
            fi
        else
            echo -e "${RED}Please install $1 to use this tool properly${RESET}"
            return 1
        fi
    fi
    return 0
}
path() {
    local IFS=$'\n'
    COMPREPLY=($(compgen -f -- "${COMP_WORDS[COMP_CWORD]}"))
}
complete -F path read

help() {
    clear
    echo -e "${MAGENTA}╔═════════════════════════════════════════════════════════════╗${RESET}"
    echo -e "${MAGENTA}║            ${CYAN}${BOLD}Sh0zack Tool Suite - Help Guide           ${MAGENTA}║${RESET}"
    echo -e "${MAGENTA}╚═════════════════════════════════════════════════════════════╝${RESET}"
    echo
    echo -e "${YELLOW}QUICK START GUIDE:${RESET}"
    echo -e "${GREEN}1. Installation:${RESET}"
    echo -e "   First time setup: ${CYAN}sudo ./scripts/install.sh${RESET}"
    echo -e "   This will install all necessary dependencies and create required directories"
    echo
    echo -e "${YELLOW}COMMAND SHORTCUTS:${RESET}"
    echo -e "${GREEN}Full Command    Shortcut    Description${RESET}"
    echo -e "port scanner    p, port     Port scanning tools"
    echo -e "dns scanner     d, dns      DNS enumeration"
    echo -e "dir scanner     dir         Directory enumeration"
    echo -e "brute force     b, brute    Password attacks"
    echo -e "listener        l, listen   Reverse shell listener"
    echo -e "privesc         priv        Privilege escalation checks"
    echo -e "shell           s, shell    Reverse shell generator"
    echo -e "decrypt         dec         Decryption tools"
    echo -e "web scanner     w, web      Web vulnerability scanning"
    echo -e "ai tool         ai          AI assistant"
    echo -e "help            h, -h , ?       Show this help menu"
    echo -e "exit            q, quit     Exit the tool"
    echo
    echo -e "${YELLOW}USAGE EXAMPLES:${RESET}"
    echo
    echo -e "${GREEN}1. Port Scanner:${RESET}"
    echo -e "   ${CYAN}Example: port -t 192.168.1.1 -p 80,443${RESET}"
    echo -e "   ${CYAN}Example: port -t example.com --all-ports${RESET}"
    echo -e "   Available tools: nmap, rustscan, custom scanner"
    echo
    echo -e "${GREEN}2. DNS Scanner:${RESET}"
    echo -e "   ${CYAN}Example: dns -d example.com -w wordlist.txt${RESET}"
    echo -e "   Tools: gobuster dns, custom DNS tool"
    echo
    echo -e "${GREEN}3. Directory Scanner:${RESET}"
    echo -e "   ${CYAN}Example: dir -u http://example.com -w wordlist.txt${RESET}"
    echo -e "   ${CYAN}Example: dir -u http://example.com --recursive${RESET}"
    echo -e "   Tools: gobuster dir, wfuzz, custom scanner"
    echo
    echo -e "${GREEN}4. Web Scanner:${RESET}"
    echo -e "   ${CYAN}Example: web -u http://example.com --full-scan${RESET}"
    echo -e "   ${CYAN}Example: web -u http://example.com --cms wordpress${RESET}"
    echo -e "   Tools: nikto, OWASP ZAP, skipfish, wpscan, cmsmap"
    echo
    echo
    echo -e "${YELLOW}COMMON SOLUTIONS:${RESET}"
    echo
    echo -e "${GREEN}1. Missing Dependencies:${RESET}"
    echo -e "   Run: ${CYAN}sudo ./scripts/install.sh${RESET}"
    echo
    echo -e "${GREEN}2. Permission Denied:${RESET}"
    echo -e "   Run tool with sudo: ${CYAN}sudo ./sh0zack.sh${RESET}"
    echo
    echo -e "${GREEN}3. API Key Issues:${RESET}"
    echo -e "   Check: ${CYAN} the openai key ${RESET}"
    echo -e "   Permissions: ${CYAN}./tools/ai.sh file ${RESET}"
    echo
    echo -e "${GREEN}4. Wordlist Not Found:${RESET}"
    echo -e "   Default lists in: ${CYAN}./sh0zack/tools${RESET}"
    echo -e "   Download more: ${CYAN}./scripts/get-wordlists.sh${RESET}"
    echo
    echo -e "${YELLOW}TOOL LOCATIONS:${RESET}"
    echo -e "Main Script:     ${CYAN}./sh0zack.sh${RESET}"
    echo -e "Tools Directory: ${CYAN}./tools/${RESET}"
    echo -e "Wordlists:       ${CYAN}./scripts/wordlists/${RESET}"
    echo -e "Payloads:         ${CYAN}./payloads/${RESET}"
    echo -e "Scripts:         ${CYAN}./scripts/${RESET}"
    echo
    echo
    echo -e "${YELLOW}OUTPUT FORMATS:${RESET}"
    echo -e "- Text files (.txt)"
    echo -e "- HTML reports"
    echo -e "- JSON format"
    echo -e "- XML output"
    echo
    echo -e "${YELLOW}PERFORMANCE TIPS:${RESET}"
    echo -e "1. Use threaded scans: ${CYAN}-t <number>${RESET}"
    echo -e "3. Target specific ports: ${CYAN}-p <ports>${RESET}"
    echo -e "4. Use custom wordlists for faster scans"
    echo
    echo -e "${YELLOW}SAFETY NOTES:${RESET}"
    echo -e "- Always have permission to scan targets"
    echo -e "- Use --delay option for rate limiting"
    echo -e "- Check local laws and regulations & use vpn if needed"
    echo -e "- Backup important results"
    echo
    echo
    echo -e "${YELLOW}SUPPORT:${RESET}"
    echo -e "Github:     ${CYAN}https://github.com/sh0z3n/Sh0zack ${RESET}"
    echo -e "Issues:     ${CYAN}https://github.com/sh0z3n/Sh0zack/issues ${RESET}"
    echo -e "Wiki:       ${CYAN}https://github.com/sh0z3n/Sh0zack/wiki ${RESET}"
    echo
    echo -e "${YELLOW}Note :${RESET}"
    echo -e "${RED}Rest of tools like xss , sqli detection and waf bypass will be comitted soon \n i really appreciate forking and submiting pull requests to suggest some modificaitons (most will be approved within a day)${RESET}"
    echo -e "${YELLOW}Press Enter to return to main menu${RESET}"
    read
}

display_main_menu() {
    clear
    echo -e "${MAGENTA}╔══════════════════════════════════╗${RESET}"
    echo -e "${MAGENTA}║         ${CYAN}${BOLD}Sh0zack Tool Suite       ${MAGENTA}║${RESET}"
    echo -e "${MAGENTA}╚══════════════════════════════════╝${RESET}"
    echo ""
    echo -e "${YELLOW}1. ${GREEN}${BOLD} Port Scanning${RESET}"
    echo -e "${YELLOW}2. ${GREEN}${BOLD} DNS Enumeration${RESET}"
    echo -e "${YELLOW}3. ${GREEN}${BOLD} Directory Fuzzer${RESET}"
    echo -e "${YELLOW}4. ${GREEN}${BOLD} Brute Force attack${RESET}"
    echo -e "${YELLOW}5. ${GREEN}${BOLD} Listener Setter${RESET}"
    echo -e "${YELLOW}6. ${GREEN}${BOLD} Privilege Escalation Check${RESET}"
    echo -e "${YELLOW}7. ${GREEN}${BOLD} Shell Generator${RESET}"
    echo -e "${YELLOW}8. ${GREEN}${BOLD} Decrypting tools ${RESET}"
     echo -e "${YELLOW}9. ${GREEN}${BOLD} Web Scanner${RESET} "
    echo -e "${YELLOW}10. ${GREEN}${BOLD}Ai Chat ${RESET} "
    echo -e "${YELLOW}11 ${RED}${BOLD} Exit${RESET}"
    echo ""
}

run_port_scanner() {
    echo -e "${YELLOW}Port Scanner${RESET}"
    echo -e "${YELLOW}Choose tool to use:${RESET}"
    echo -e "${GREEN}1. Nmap${RESET}"
    echo -e "${GREEN}2. Rustscan${RESET}"
    echo -e "${GREEN}3. Shozack Port Scan Tool${RESET}"
    read -p "Enter your choice: " tool_choice

    read -p "Enter target: " target
    if [ "$tool_choice" -eq 1 ]; then
        cmd_ulach "nmap" || return
        echo -e "${BLUE}Example Nmap usage: nmap -sV -p 1-65535 $target${RESET}"
        read -p "Enter Nmap command options: " nmap_options
        nmap $nmap_options $target
    elif [ "$tool_choice" -eq 2 ]; then
        cmd_ulach "rustscan" || return
        echo -e "${BLUE}Example Rustscan usage: rustscan -a $target --ulimit 5000 -- -sV${RESET}"
        read -p "Enter Rustscan command options: " rustscan_options
        rustscan $rustscan_options $target
    elif [ "$tool_choice" -eq 3 ]; then
        echo -e "${BLUE}Example Shozack Port Scan Tool usage: ./tools/port-scanner.sh $target${RESET}"
        read -p "Enter Shozack Port Scan Tool options: " shozack_options
        ./tools/port-scanner.sh $target $shozack_options
    else
        echo -e "${RED}Invalid option.${RESET}"
    fi
}
run_dns_scanner() {
    echo -e "${YELLOW}DNS Scanner${RESET}"
    echo -e "${YELLOW}Choose tool to use:${RESET}"
    echo -e "${GREEN}1. Gobuster${RESET}"
    echo -e "${GREEN}2. Advanced Sh0zack DNS Scan Tool${RESET}"
    read -p "Enter your choice: " tool_choice
    read -p "Enter URL: " url
    read -e -p "Enter path to wordlist (leave empty for default): " wordlist
    if [ -z "$url" ];then
        echo -e "\n${RED} $BOLD You didn't provide a target URL , No scanning for you :(  ${RESET}"
        return
    fi

    if [ -z "$wordlist" ]; then
        default_wordlist="tools/default_subdomains.txt"
        if [ ! -f "$default_wordlist" ]; then

            if ! which curl >/dev/null 2>&1; then
                if [ "$EUID" -ne 0 ]; then
                echo "run as root" &&  exit 1 # just to ensure u get curl on ur machine
                fi
                #echo "curl not found, installing..."
                #sudo apt-get install -y curl
            fi
            echo -e "${YELLOW}Default wordlist not found. Downloading...${RESET}"
            curl -s "https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/DNS/subdomains-top1million-5000.txt" -o "$default_wordlist"
            if [ $? -ne 0 ]; then
                echo -e "${RED}Failed to download default wordlist. Please provide a wordlist you have locally.${RESET}"
                return
            fi
            echo -e "${GREEN}Default wordlist downloaded successfully.${RESET}"
        else
            echo -e "${GREEN}Using existing default wordlist.${RESET}"
        fi
        wordlist="$default_wordlist"
    elif [ ! -f "$wordlist" ]; then
        echo -e "${RED}Error: Wordlist file not found.${RESET}"
        return
    fi

    case $tool_choice in
        1)  cmd_ulach "gobuster" || return;
            echo -e "${BLUE}Running Gobuster...${RESET}"
            echo -e "${BLUE}Your Gobuster usage: gobuster dns -d $url -w $wordlist${RESET}"
            gobuster dns -d "$url" -w "$wordlist"
            ;;
        2)
            echo -e "${BLUE}Running Advanced Sh0zack DNS Scan Tool...${RESET}"
            read -p "Enter number of threads (default: 50): " threads
            read -p "Enter timeout in seconds (default: 5): " timeout
            read -p "Resolve IP addresses? (y/n, default: y): " resolve_ip
            read -p "Enable verbose mode? (y/n, default: n): " verbose
            read -p "Enter output file name (default: subdomain_results.txt): " output_file

            threads=${threads:-50}
            timeout=${timeout:-5}
            resolve_ip=${resolve_ip:-y}
            verbose=${verbose:-n}
            output_file=${output_file:-subdomain_results.txt}

            cmd_args="-u '$url' -w '$wordlist' -o '$output_file' -t $threads -T $timeout"
            [ "$resolve_ip" = "n" ] && cmd_args="$cmd_args -n"
            [ "$verbose" = "y" ] && cmd_args="$cmd_args -v"

            echo -e "${BLUE}Running command: ./tools/dns.sh $cmd_args${RESET}"
            eval "./tools/dns.sh $cmd_args"
            ;;
        *)
            echo -e "${RED}Invalid option.${RESET}"
            ;;
    esac
#  you can uncomment this if you wanna delete the file after downloading it
#     if [ "$wordlist" = "tools/default_subdomains.txt" ]; then
#         rm "$wordlist"
#     fi
}
run_dir_scanner() {
    echo -e "${YELLOW}Directory Scanner${RESET}"
    echo -e "${YELLOW}Choose tool to use:${RESET}"
    echo -e "${GREEN}1. Gobuster${RESET}"
    echo -e "${GREEN}2. WFuzz${RESET}"
    echo -e "${GREEN}3. Advanced Sh0zack Directory Scan Tool${RESET}"
    read -p "Enter your choice: " tc
    read -p "Enter URL: " url
    read -e -p "Enter path to wordlist (leave empty for default): " wl

    if [ -z "$url" ]; then
        echo -e "\n${RED}${BOLD}You didn't provide a target URL. No scanning for you :( ${RESET}"
        return
    fi

    if [ -z "$wl" ]; then
        dw="tools/default_dirlist.txt"
        if [ ! -f "$dw" ]; then
            if ! which curl >/dev/null 2>&1; then
                if [ "$EUID" -ne 0 ]; then
                    echo -e "${RED}Run as root${RESET}" && exit 1
                fi
                #echo -e "${YELLOW}curl not found, installing...${RESET}"
                #sudo apt-get install -y curl
            fi
            echo -e "${YELLOW}Default worsudo apt-getdlist not found. Downloading...${RESET}"
            curl -s "https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/common.txt" -o "$dw"
            if [ $? -ne 0 ]; then
                echo -e "${RED}Failed to download default wordlist. Please provide a wordlist you have locally.${RESET}"
                return
            fi
            echo -e "${GREEN}Default wordlist downloaded successfully.${RESET}"
        else
            echo -e "${GREEN}Using existing default wordlist.${RESET}"
        fi
        wl="$dw"
    elif [ ! -f "$wl" ]; then
        echo -e "${RED}Error: Wordlist file not found.${RESET}"
        return
    fi

    case $tc in
        1)
            cmd_ulach "gobuster" || return;
            echo -e "${BLUE}Running Gobuster...${RESET}"
            echo -e "${BLUE}Your Gobuster usage: gobuster dir -u $url -w $wl${RESET}"
            gobuster dir -u "$url" -w "$wl"
            ;;
        2)  cmd_ulach "wfuzz" || return;
            echo -e "${BLUE}Running WFuzz...${RESET}"
            echo -e "${BLUE}Your WFuzz usage: wfuzz -c -z file,$wl --hc 404 $url/FUZZ${RESET}"
            wfuzz -c -z file,$wl --hc 404 "$url/FUZZ"
            ;;
        3)
            echo -e "${BLUE}Running Advanced Sh0zack Directory Scan Tool...${RESET}"
            read -p "Enter number of threads (default: 50): " thrd
            read -p "Enter timeout in seconds (default: 5): " to
            read -p "Enable verbose mode? (y/n, default: n): " vb
            read -p "Enter output file name (default: dir_results.txt): " of

            thrd=${thrd:-50}
            to=${to:-5}
            vb=${vb:-n}
            of=${of:-dir_results.txt}

            ca="-u '$url' -w '$wl' -o '$of' -t $thrd -T $to"
            [ "$vb" = "y" ] && ca="$ca -v"

            echo -e "${BLUE}Running command: ./tools/dir.sh $ca${RESET}"
            eval "./tools/dir.sh $ca"
            ;;
        *)
            echo -e "${RED}Invalid option.${RESET}"
            ;;
    esac
}


run_brute_force() {
    echo -e "${YELLOW}Brute Force${RESET}"
    echo -e "${YELLOW}Choose tool to use:${RESET}"
    echo -e "${GREEN}1. Hydra${RESET}"
    echo -e "${GREEN}2. Shozack Brute Force Tool${RESET}"
    read -p "Enter your choice: " tool_choice

    read -p "Enter target: " target
    read -e -p "Enter path to user wordlist: " user_wordlist
    read -e -p "Enter path to password wordlist: " pass_wordlist
    read -p "Enter number of threads: " threads
    read -p "Enter service (e.g., ssh, ftp): " service
    read -p "Enter port (optional): " port
    read -e -p "Enter path to output file (optional): " output_file

    if [ "$tool_choice" -eq 1 ]; then
        cmd_ulach "hydra" || return;
        echo -e "${BLUE}Example Hydra usage: hydra -L $user_wordlist -P $pass_wordlist -t $threads $service://$target${RESET}"
        hydra -L $user_wordlist -P $pass_wordlist -t $threads $service://$target
    elif [ "$tool_choice" -eq 2 ]; then
        echo -e "${BLUE}Example Shozack Brute Force Tool usage: ./tools/brute-force.sh -t $target -u $user_wordlist -p $pass_wordlist -T $threads -s $service${RESET}"
        ./tools/brute-force.sh -t $target -u $user_wordlist -p $pass_wordlist -T $threads -s $service
    else
        echo -e "${RED}Invalid option.${RESET}"
    fi
}

run_listener() {
    echo -e "${YELLOW}Listener${RESET}"
    ./tools/listener.sh
}

run_privesc_check() {
    echo -e "${YELLOW}Privilege Escalation Check${RESET}"
    ./tools/privesc.sh
}

run_shell_generator() {
    echo -e "${YELLOW}Shell Generator${RESET}"
    ./tools/shell-generator.sh
}

run_web_scanner() {
    echo -e "${YELLOW}Web Scanner${RESET}"
    read -p "Enter the target website URL: " web_target

    echo -e "${YELLOW}Choose web scanning tool:${RESET}"
    echo -e "${GREEN}1. Nikto${RESET}"
    echo -e "${GREEN}2. OWASP ZAP (command line)${RESET}"
    echo -e "${GREEN}3. Skipfish${RESET}"
    echo -e "${GREEN}4. WPScan (WordPress)${RESET}"
    echo -e "${GREEN}5. CMSmap (WordPress and other CMS)${RESET}"
    read -p "Enter your choice: " web_tool_choice

    case $web_tool_choice in
        1)
            echo -e "${BLUE}Running Nikto...${RESET}"
            cmd_ulach "nikto" || return;
            nikto -h "$web_target"
            ;;
        2)
            echo -e "${BLUE}Running OWASP ZAP...${RESET}"
            cmd_ulach "zap-cli" || return;
            zap-cli quick-scan -s all -r "$web_target"
            ;;
        3)
            echo -e "${BLUE}Running Skipfish...${RESET}"
            cmd_ulach "skipfish" || return;
            read -p "Enter output directory: " output_dir
            skipfish -o "$output_dir" "$web_target"
            ;;
        4)
            echo -e "${BLUE}Running WPScan...${RESET}"
            echo -e "${YELLOW}Note: This is specific to WordPress sites.${RESET}"
            cmd_ulach "wpscan" || return;
            wpscan --url "$web_target" --enumerate p,t,u
            ;;
        5)
            echo -e "${BLUE}Running CMSmap...${RESET}"
            echo -e "${YELLOW}Note: This works for WordPress and other CMS.${RESET}"
            cmd_ulach "cmsmap" || return;
            cmsmap "$web_target"
            ;;
        *)
            echo -e "${RED}Invalid option.${RESET}"
            ;;
    esac
}

run_AI(){
	echo -e "${YELLOW}AI Tool ${RESET}"
	./tools/ai.sh
}

run_decrypte() {
    echo -e "${YELLOW}Decrypting tools${RESET}"
    echo -e "${YELLOW}Choose decryption method:${RESET}"
    echo -e "${GREEN}1. FROM Base64${RESET}"
    echo -e "${GREEN}2. FROM Base32${RESET}"
    echo -e "${GREEN}3. FROM Base85${RESET}"
    echo -e "${GREEN}4. FROM Base58${RESET}"
    echo -e "${GREEN}5. Vigenère${RESET}"
    echo -e "${GREEN}6. ROT13${RESET}"
    echo -e "${GREEN}7. ROT47${RESET}"
    echo -e "${GREEN}8. Binary to Text${RESET}"
    echo -e "${GREEN}9. Hexadecimal to Text${RESET}"
    read -p "Enter your choice: " decrypt_choice

    case $decrypt_choice in
        1)
            read -p "Enter Base64 string to decrypt: " base64_input
            cmd_ulach "bas64" || return;
            echo -n "$base64_input" | base64 -d
            ;;
        2)
            read -p "Enter Base32 string to decrypt: " base32_input
            cmd_ulach "base32" || return;
            echo -n "$base32_input" | base32 -d
            ;;
        3)
            read -p "Enter Base85 string to decrypt: " base85_input
            cmd_ulach "base85" || return;
            echo -n "$base85_input" | base85 -d
            ;;
        4)
            read -p "Enter Base58 string to decrypt: " base58_input
            cmd_ulach "base58" || return;
            python3 -c "
import base58
print(base58.b58decode('$base58_input').decode())
"
            ;;
        5)
            read -p "Enter Vigenère encrypted text: " vigenere_input
            read -p "Enter Vigenère key: " vigenere_key
            python3 -c "
import sys

def vigenere_decrypt(ct, key):
    pt = ''
    l = len(key)
    for i, char in enumerate(ct):
        if char.isalpha():
            shift = ord(key[i % l].upper()) - ord('A')
            if char.isupper():
                pt += chr((ord(char) - shift - 65) % 26 + 65)
            else:
                pt += chr((ord(char) - shift - 97) % 26 + 97)
        else:
            pt += char
    return pt

ct = '$vigenere_input'
key = '$vigenere_key'
print(vigenere_decrypt(ct, key))
"
            ;;
        6)
            read -p "Enter ROT13 string to decrypt: " rot13_input
            echo "$rot13_input" | tr 'A-Za-z' 'N-ZA-Mn-za-m'
            ;;
        7)
            read -p "Enter ROT47 string to decrypt: " rot47_input
            python3 -c "
import codecs
print(codecs.decode('$rot47_input', 'rot47'))
"
            ;;
        8)
            read -p "Enter binary string to decrypt (space-separated): " binary_input
            python3 -c "
binary = '$binary_input'.split()
text = ''.join([chr(int(byte, 2)) for byte in binary])
print(text)
"
            ;;
        9)
            read -p "Enter hexadecimal string to decrypt: " hex_input
            python3 -c "
hex_string = '$hex_input'
text = bytes.fromhex(hex_string).decode('utf-8')
print(text)
"
            ;;
        *)
            echo -e "${RED}Invalid option.${RESET}"
            ;;
    esac


}
    display_main_menu

while true; do
    display_main_menu
    echo -en "${CYAN}${PROMPT}${RESET}"
    read -p " " choice

    case $choice in
        0|h|-h|help|?|--help|-help) help ;;
        1|port) run_port_scanner ;;
        2|dns) run_dns_scanner ;;
        3|dir) run_dir_scanner ;;
        4|brute) run_brute_force ;;
        5|listen) run_listener ;;
        6|privesc) run_privesc_check ;;
        7|shell) run_shell_generator ;;
        8|cron) run_decrypte ;;
        9|web) run_web_scanner;;
	10|Ai) run_AI;;
        11|exit|quit|q|:wq) echo -e "${RED}Exiting Shozack !!!${RESET}"; exit 0 ;;
        *) echo -e "${RED}Invalid option. Repeat your choice.${RESET}" ;;
    esac

    echo
    read -p "Press enter to continue..."
done
