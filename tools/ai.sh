#!/bin/bash

# ANSI color 
BOLD='\033[1m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
RESET='\033[0m'

# AI Providers llms 
GEMINI_KEY="GEMINI-KEY"
OPENAI_KEY="OPENai key"
CLAUDE_KEY="YOUR_CLAUDE_API_KEY"
KNOWLEDGE_GRAPH_API_KEY="YOUR_KNOWLEDGE_GRAPH_API_KEY" # .

function choose_ai_provider() {
    echo -e "${BLUE} Choose AI Provider: ${YELLOW}1. Gemini ${YELLOW}2. OpenAI ${YELLOW}3. Claude ${YELLOW}4. Knowledge Graph ${RESET}"
    read -p "Select (1-4): " AI_CHOICE

    case $AI_CHOICE in
        1)
            AI_PROVIDER="Gemini"
            ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$GEMINI_KEY"
            ;;
        2)
            AI_PROVIDER="OpenAI"
            ENDPOINT="https://api.openai.com/v1/chat/completions"
            ;;
        3)
            AI_PROVIDER="Claude"
            ENDPOINT="https://api.anthropic.com/v1/claude" # Replace with the actual Claude endpoint if available
            ;;
        4)
            AI_PROVIDER="Knowledge Graph"
            ENDPOINT="https://kgsearch.googleapis.com/v1/entities:search?key=$KNOWLEDGE_GRAPH_API_KEY"
            ;;
        *)
            echo -e "${RED} Invalid choice. Exiting... ${RESET}"
            exit 1
            ;;
    esac
}

function typewriter() {
    local text="$1"
    local delay=0.06
    for (( i=0; i<${#text}; i++ )); do
        echo -ne "${text:i:1}"
        sleep $delay
    done
    echo
}

function send_request() {
    local user_input="$1"
    local response=""

    if [ "$AI_PROVIDER" == "Gemini" ]; then
        response=$(curl -s -H 'Content-Type: application/json' \
          -d "{\"contents\":[{\"parts\":[{\"text\":\"$user_input\"}]}]}" \
          -X POST "$ENDPOINT")
    elif [ "$AI_PROVIDER" == "OpenAI" ]; then
        response=$(curl -s -H "Authorization: Bearer $OPENAI_KEY" \
          -H "Content-Type: application/json" \
          -d "{\"model\": \"gpt-3.5-turbo\", \"messages\":[{\"role\":\"user\", \"content\":\"$user_input\"}]}" \
          -X POST "$ENDPOINT")
    elif [ "$AI_PROVIDER" == "Claude" ]; then
        response=$(curl -s -H "Authorization: Bearer $CLAUDE_KEY" \
          -H "Content-Type: application/json" \
          -d "{\"prompt\":\"$user_input\",\"max_tokens\":1000}" \
          -X POST "$ENDPOINT")
    elif [ "$AI_PROVIDER" == "Knowledge Graph" ]; then
        response=$(curl -s -H "Content-Type: application/json" \
          -d "{\"query\":\"$user_input\",\"limit\":1,\"types\":[]}" \
          -X GET "$ENDPOINT")
    fi

    echo "$response"
}

function display_response() {
    local response="$1"
    local res=$(echo "$response" | jq -r '.candidates[0].content.parts[0].text // .choices[0].message.content // .result.entities[0].description' | tr -d '\r\n' | sed 's/^[ \t]*//;s/[ \t]*$//')

    echo -e "${MAGENTA}===================================================${RESET}"
    
    echo -e "${CYAN}AI RESPONSE:${RESET}"
    echo -e "${YELLOW}---------------------------------------------------${RESET}"

    #  wrap long lines using the fold command ! 
    echo -e "${GREEN}${BOLD}$(echo "$res" | fold -s -w 90)${RESET}"
    
    echo -e "${MAGENTA}===================================================${RESET}"
}

# function analyze_user_intent() { idk but it's not the best approach to help by just analyzing what u send
#     local user_input="$1"
#     local response=$(send_request "user's intent based on the input: $user_input?")
#     local intent=$(echo "$response" | jq -r '.candidates[0].content.parts[0].text // .choices[0].message.content // .result.entities[0].description' | tr -d '\r\n' | sed 's/^[ \t]*//;s/[ \t]*$//')

#     echo "$intent"
# }

function provide_ctf_guidance() {
    local challenge_type=$1
    local response=""

    if [ "$challenge_type" == "Cryptography" ]; then
        response=$(send_request "As an AI assistant, please provide step-by-step guidance on how to approach and solve cryptography-based CTF challenges.")
    elif [ "$challenge_type" == "Steganography" ]; then
        response=$(send_request "As an AI assistant, please provide step-by-step guidance on how to approach and solve steganography-based CTF challenges.")
    elif [ "$challenge_type" == "Reverse Engineering" ]; then
        response=$(send_request "As an AI assistant, please provide step-by-step guidance on how to approach and solve reverse engineering-based CTF challenges.")
    elif [ "$challenge_type" == "Binary Exploitation" ]; then
        response=$(send_request "As an AI assistant, please provide step-by-step guidance on how to approach and solve binary exploitation-based CTF challenges.")
    elif [ "$challenge_type" == "Web Hacking" ]; then
        response=$(send_request "As an AI assistant, please provide step-by-step guidance on how to approach and solve web hacking-based CTF challenges.")
    else
        response=$(send_request "As an AI assistant, please provide general guidance on how to approach and solve CTF challenges.")
    fi

    display_response "$response"
}

function provide_pentesting_guidance() {
    local task=$1
    local response=""

    if [ "$task" == "Network Reconnaissance" ]; then
        response=$(send_request "As an AI assistant, please provide detailed guidance on how to perform effective network reconnaissance using the Sh0zack tool.")
    elif [ "$task" == "Vulnerability Identification" ]; then
        response=$(send_request "As an AI assistant, please provide guidance on how to identify vulnerabilities in target systems and web applications using the Sh0zack tool.")
    elif [ "$task" == "Exploitation" ]; then
        response=$(send_request "As an AI assistant, please provide guidance on how to perform exploitation techniques using the Sh0zack tool, including the use of appropriate tools and methods.")
    elif [ "$task" == "Privilege Escalation" ]; then
        response=$(send_request "As an AI assistant, please provide guidance on how to identify and exploit privilege escalation vectors on a target system using the Sh0zack tool.")
    elif [ "$task" == "Maintaining Access" ]; then
        response=$(send_request "As an AI assistant, please provide guidance on how to maintain access to a target system using the Sh0zack tool, including the use of listeners and other techniques.")
    elif [ "$task" == "Reporting and Documentation" ]; then
        response=$(send_request "As an AI assistant, please provide guidance on how to effectively document the findings and steps taken during a penetration testing engagement using the Sh0zack tool.")
    else
        response=$(send_request "As an AI assistant, please provide general guidance on how to perform effective penetration testing using the Sh0zack tool.")
    fi

    display_response "$response"
}

function provide_tool_guidance() {
    local tool=$1
    local response=""

    if [ "$tool" == "portscan.sh" ]; then
        response=$(send_request "As an AI assistant, please provide detailed guidance on how to use the ./tools/portscan.sh tool for efficient port scanning.")
    elif [ "$tool" == "dns.sh" ]; then
        response=$(send_request "As an AI assistant, please provide detailed guidance on how to use the ./tools/dns.sh tool for effective DNS enumeration.")
    elif [ "$tool" == "dirscan.sh" ]; then
        response=$(send_request "As an AI assistant, please provide detailed guidance on how to use the ./tools/dirscan.sh tool for directory fuzzing and file discovery.")
    elif [ "$tool" == "bruteforce.sh" ]; then
        response=$(send_request "As an AI assistant, please provide detailed guidance on how to use the ./tools/bruteforce.sh tool for brute-force attacks.")
    elif [ "$tool" == "listener.sh" ]; then
        response=$(send_request "As an AI assistant, please provide detailed guidance on how to use the ./tools/listener.sh tool for setting up a listener to catch reverse shells.")
    elif [ "$tool" == "privesc.sh" ]; then
        response=$(send_request "As an AI assistant, please provide detailed guidance on how to use the ./tools/privesc.sh tool for identifying potential privilege escalation vectors.")
    elif [ "$tool" == "decrypt.sh" ]; then
        response=$(send_request "As an AI assistant, please provide detailed guidance on how to use the ./tools/decrypt.sh tool for decrypting encoded data.")
    elif [ "$tool" == "webscan.sh" ]; then
        response=$(send_request "As an AI assistant, please provide detailed guidance on how to use the ./tools/webscan.sh tool for web vulnerability scanning.")
    else
        response=$(send_request "As an AI assistant, please provide general guidance on the various tools available in the Sh0zack framework.")
    fi

    display_response "$response"
}


function AI () {
    choose_ai_provider

    typewriter "$(echo -e "${RED}Ai is Ready ...${RESET}")"

    echo -e "${YELLOW}Welcome to Sh0zack AI-powered CTF and Penetration Testing Assistant! How can I help you today? ${RESET}"

    while true; do
        read -p "$(echo -e '\e[5m'"${BLUE} => ${RESET}"'\e[0m')" AI_PROMPT

        response=$(send_request "$AI_PROMPT")
        display_response "$response"

    done
}

AI  