#!/bin/bash

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

custom_url=""
wordlist=""
output_file=""
threads=50
timeout=5
resolve_ip=true
verbose=false

usage() {
    echo -e "${BLUE}Usage: $0 -u <url> -w <wordlist> [OPTIONS]${NC}"
    echo -e "Example: $0 -u example.com -w subdomains.txt -o results.txt -t 100 -v"
    echo -e "\nOptions:"
    echo -e "  -u <url>       Target URL (required)"
    echo -e "  -w <wordlist>  Path to wordlist file (required)"
    echo -e "  -o <file>      Output file (default: subdomain_results.txt)"
    echo -e "  -t <number>    Number of threads (default: 50)"
    echo -e "  -T <seconds>   Timeout for DNS queries (default: 5)"
    echo -e "  -n             Do not resolve IP addresses"
    echo -e "  -v             Verbose mode"
    exit 1
}

# Parse command-line arguments
while getopts "u:w:o:t:T:nv" opt; do
    case $opt in
        u) custom_url="$OPTARG" ;;
        w) wordlist="$OPTARG" ;;
        o) output_file="$OPTARG" ;;
        t) threads="$OPTARG" ;;
        T) timeout="$OPTARG" ;;
        n) resolve_ip=false ;;
        v) verbose=true ;;
        *) usage ;;
    esac
done

if [ -z "$custom_url" ] || [ -z "$wordlist" ]; then
    usage
fi

if [ -z "$output_file" ]; then
    output_file="shozack-subdomain_results.txt"
fi

#  URL has a protocol
if [[ "$custom_url" != http://* && "$custom_url" != https://* ]]; then
    custom_url="http://$custom_url"
fi

domain=$(echo "$custom_url" | awk -F[/:] '{print $4}')

check_wordlist() {
    if [ ! -f "$wordlist" ]; then
        echo -e "${YELLOW}Wordlist not found. Downloading from $custom_url...${NC}"
        curl -sSL "$custom_url" -o "$wordlist"
        if [ $? -ne 0 ]; then
            echo -e "${RED}Failed to download wordlist. Exiting.${NC}"
            exit 1
        fi
    else
        echo -e "${GREEN}Using existing wordlist: $wordlist${NC}"
    fi
}

dns_enum() {
    local subdomain="$1"
    local full_domain="$subdomain.$domain"
    local result=""

    if $resolve_ip; then
        result=$(timeout $timeout host "$full_domain" 2>/dev/null | grep 'has address' | head -n 1)
        if [ -n "$result" ]; then
            local ip=$(echo "$result" | awk '{print $NF}')
            echo -e "$full_domain : $ip"
        elif $verbose; then
            echo "$full_domain,No IP" >&2
        fi
    else
        if timeout $timeout host "$full_domain" 2>/dev/null | grep -q 'has address'; then
            echo "$full_domain"
        elif $verbose; then
            echo "$full_domain,Not found" >&2
        fi
    fi
}

export -f dns_enum
export resolve_ip
export verbose
export timeout
export domain

print_banner() {
    echo -e "${MAGENTA}"
    echo "============================================"
    echo "   Sh0zack Advanced DNS Subdomain Enumerator"
    echo "============================================"
    echo -e "${NC}"
    echo -e "${CYAN}Target URL:${NC} $custom_url"
    echo -e "${CYAN}Wordlist:${NC} $wordlist"
    echo -e "${CYAN}Output File:${NC} $output_file"
    echo -e "${CYAN}Threads:${NC} $threads"
    echo -e "${CYAN}Timeout:${NC} $timeout seconds"
    echo -e "${CYAN}Resolve IP:${NC} $resolve_ip"
    echo -e "${CYAN}Verbose:${NC} $verbose"
    echo "============================================"
}

main() {
    print_banner
    check_wordlist

    echo -e "${GREEN}Starting enumeration...${NC}"
    start_time=$(date +%s)

    xargs -P $threads -I {} -a "$wordlist" bash -c 'dns_enum "$@"' _ {} | tee "$output_file"

    end_time=$(date +%s)
    duration=$((end_time - start_time))

    subs=$(wc -l < "$output_file")

    echo -e "\n${GREEN}Enumeration complete!${NC}"
    echo -e "${CYAN}Total subdomains found:${NC} $subs"
    echo -e "${CYAN}Time taken:${NC} $duration seconds"
    echo -e "${CYAN}Results saved to:${NC} $output_file"
}

main
