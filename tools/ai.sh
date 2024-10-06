#!/bin/bash


#this is a very minimzed and limited ai-tool to help generating commands and pentest>
# ANSI color codes
BOLD='\033[1m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
RESET='\033[0m'

# AI Gateway Key; this key is time-limited; use yours from api.gemini.com
echo -e "${BLUE} Please provide your Gemini key (press Enter to use default) ${RESET}"
read -p "" KEY
if  [ ! -z "KEY" ];then
 KEY="AIzaSyCYvh-4x_m83w0j1XVVaPasqVgYivPxOAE"
fi

typewriter() {
    local text="$1"
    local delay=0.06
    for (( i=0; i<${#text}; i++ )); do
        echo -ne "${text:i:1}"
        sleep $delay
    done
    echo
}

typewriter $(echo -e "${RED} Wait...${RESET}")
# Endpoint URL
ENDPOINT="https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$KEY"

#ready prompt : 
prompt="As a penetration testing expert, your role will be to help identify potential vulnerabilities in a system or network by performing penetration tests. This may include using a variety of tools and techniques to simulate attacks and identify weaknesses, creating detailed reports of findings and recommendations for improving security, and working with the team to develop strategies for preventing future attacks. Your expertise in network security will be particularly valuable in ensuring that any penetration testing work performed is done in a secure and controlled manner. As a CTF security expert, your role will be to provide guidance on security challenges and potential vulnerabilities in CTF competitions. This may include reviewing challenges to identify potential exploits or vulnerabilities, suggesting ways to improve the security of the challenges and the competition as a whole, and recommending tools or techniques that can be used to detect and prevent potential threats. Your expertise in network security and CTF competitions will be particularly valuable in ensuring that the competition is conducted in a secure and controlled manner. I will provide you with some problem scenarios later. You need to find solutions and methods for me based on the scenarios. If you understand your responsibilities, make simple responses and not so complicated "

curl_response=$(curl -s -H 'Content-Type: application/json' \
  -d "{\"contents\":[{\"parts\":[{\"text\":\"$prompt\"}]}]}" \
  -X POST "$ENDPOINT")



echo -e "${YELLOW} Hey, I'm your AI Sh0zack Assistant, how can I help you during your pentesting? ${RESET} "

read -p "$(echo -e '\e[5m'"${BLUE} => ${RESET}"'\e[0m')" AI

response=$(curl -s -H 'Content-Type: application/json' \
  -d "{\"contents\":[{\"parts\":[{\"text\":\"$AI\"}]}]}" \
  -X POST "$ENDPOINT")


res=$(echo "$response" | jq -r '.candidates[0].content.parts[0].text' | tr -d '\r\n' | sed 's/^[ \t]*//;s/[ \t]*$//' | sed 's/\*\*/\n/g'
)

# Print the extracted text
echo -e "${CYAN}AI RESPONSE :${RESET}"
echo -e "${YELLOW}1. ${GREEN}${BOLD} $res ${RESET}"

