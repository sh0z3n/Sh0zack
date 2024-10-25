#!/bin/bash
#that's a reaaaaly limited web crawler , it is used only for small exposed sites ( won`t work with all sites )
read -p "$(echo -e '\e[5m'"${BLUE} Set the URL to crawl ${RESET}"'\e[0m')" START_URL

MAX_DEPTH=5
VISITED_FILE="vis-urls.txt"

> "$VISITED_FILE"

crawl_page() {
    local url=$1
    local depth=$2

    if grep -Fxq "$url" "$VISITED_FILE"; then
        return
    fi

    echo "$url" >> "$VISITED_FILE"

    local html_content=$(curl -s "$url")

    local links=$(echo "$html_content" | grep -oP '(?<=href=")[^"]+' | grep -E '^https?://')

    echo "Crawling $url at depth $depth"

    if [ "$depth" -ge "$MAX_DEPTH" ]; then
        return
    fi

    for link in $links; do
        crawl_page "$link" $((depth + 1))
    done
}

crawl_page "$START_URL" 0

echo "Crawling completed. Visited URLs are saved in $VISITED_FILE."
