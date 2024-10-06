#!/bin/bash

# Color definitions
R='\033[0;31m'
G='\033[0;32m'
Y='\033[1;33m'
B='\033[0;34m'
M='\033[0;35m'
C='\033[0;36m'
W='\033[1;37m'
RST='\033[0m'

url=""
wordlist=""
output_file=""
threads=50
timeout=5
verbose=false

usage() {
    echo -e "${Y}Usage: $0 -u <url> -w <wordlist> [OPTIONS]${RST}"
    echo -e "${Y}Example: $0 -u http://example.com -w /path/to/wordlist.txt -o results.txt -t 100 -v${RST}"
    echo ""
    echo -e "${G}Options:${RST}"
    echo -e "  ${B}-u <url>       ${W}Target URL (required)${RST}"
    echo -e "  ${B}-w <wordlist>  ${W}Path to wordlist file (required)${RST}"
    echo -e "  ${B}-o <file>      ${W}Output file (default: dir_results.txt)${RST}"
    echo -e "  ${B}-t <number>    ${W}Number of threads (default: 50)${RST}"
    echo -e "  ${B}-T <seconds>   ${W}Timeout for requests (default: 5)${RST}"
    echo -e "  ${B}-v             ${W}Verbose mode${RST}"
    exit 1
}

while getopts "u:w:o:t:T:v" opt; do
    case $opt in
        u) url="$OPTARG" ;;
        w) wordlist="$OPTARG" ;;
        o) output_file="$OPTARG" ;;
        t) threads="$OPTARG" ;;
        T) timeout="$OPTARG" ;;
        v) verbose=true ;;
        *) usage ;;
    esac
done

if [ -z "$url" ] || [ -z "$wordlist" ]; then
    usage
fi

if [ -z "$output_file" ]; then
    output_file="dir_results.txt"
fi

dir_enum() {
    local endpoint="$1"
    local response=$(curl -s -o /dev/null -w "%{http_code}" -m "$timeout" "$url/$endpoint")
    local status=""
    local color=""
    case "$response" in
        200) status="Found"; color=$G ;;
        3*) status="Redirect"; color=$Y ;;
        401) status="Unauthorized"; color=$R ;;
        403) status="Forbidden"; color=$M ;;
        500) status="Server Error"; color=$R ;;
        *) return ;;  # ulach other status codes
    esac
    echo -e "${color}| $(printf "%-50s" "$url/$endpoint") | $(printf "%-15s" "$status ($response)") |${RST}"
}

enumerate() {
    local total_lines=$(wc -l < "$wordlist")
    local counter=0
    local start_time=$(date +%s)

    echo -e "${W}| Directory                                          | Status          |${RST}"
    echo -e "${W}|----------------------------------------------------|-----------------|${RST}"

    export -f dir_enum
    export url timeout verbose
    export R G Y B M C W RST

    cat "$wordlist" | xargs -P "$threads" -I {} bash -c 'dir_enum "$@"' _ {} | tee -a >(sed "s/\x1B\[[0-9;]*[JKmsu]//g" > "$output_file")

    local end_time=$(date +%s)
    local duration=$((end_time - start_time))

    echo -e "${Y}=========================================================================${RST}"
    echo -e "${G}Directory enumeration complete.${RST}"
    echo -e "${B}Total entries processed: ${W}$total_lines${RST}"
    echo -e "${B}Time taken: ${W}$duration seconds${RST}"
    echo -e "${B}Results saved to: ${W}$output_file${RST}"
}

echo -e "${M}Starting directory enumeration on $url using wordlist: $wordlist...${RST}"
echo -e "${Y}======================================================================${RST}"
enumerate
