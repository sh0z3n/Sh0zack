#!/bin/bash
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
        return 1
    fi
    return 0
}
path() {
    local IFS=$'\n'
    COMPREPLY=($(compgen -f -- "${COMP_WORDS[COMP_CWORD]}"))
}
complete -F path read
display_main_menu() {
    clear
    echo -e "${MAGENTA}╔══════════════════════════════════╗${RESET}"
    echo -e "${MAGENTA}║         ${CYAN}${BOLD}Sh0zack Tool Suite       ${MAGENTA}║${RESET}"
    echo -e "${MAGENTA}╚══════════════════════════════════╝${RESET}"
    echo ""
    echo -e "${YELLOW}1. ${GREEN}${BOLD} Port Scanner${RESET}"
    echo -e "${YELLOW}2. ${GREEN}${BOLD} DNS Scanner${RESET}"
    echo -e "${YELLOW}3. ${GREEN}${BOLD} Directory Scanner${RESET}"
    echo -e "${YELLOW}4. ${GREEN}${BOLD} Brute Force${RESET}"
    echo -e "${YELLOW}5. ${GREEN}${BOLD} Listener${RESET}"
    echo -e "${YELLOW}6. ${GREEN}${BOLD} Privilege Escalation Check${RESET}"
    echo -e "${YELLOW}7. ${GREEN}${BOLD} Shell Generator${RESET}"
    echo -e "${YELLOW}8. ${GREEN}${BOLD} Decrypting tools ${RESET}"
     echo -e "${YELLOW}9. ${GREEN}${BOLD} Web Scanner${RESET} "
    echo -e "${YELLOW}10. ${GREEN}${BOLD} Ai Tool ${RESET} "
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
                echo "curl not found, installing..."
                sudo apt-get install -y curl
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
                echo -e "${YELLOW}curl not found, installing...${RESET}"
                sudo apt-get install -y curl
            fi
            echo -e "${YELLOW}Default wordlist not found. Downloading...${RESET}"
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
        11|exit|quit) echo -e "${RED}Exiting Shozack !!!${RESET}"; exit 0 ;;
        *) echo -e "${RED}Invalid option. Repeat your choice.${RESET}" ;;
    esac

    echo
    read -p "Press enter to continue..."
done
