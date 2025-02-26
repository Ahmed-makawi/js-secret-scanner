#!/bin/bash

extract_secrets() {
    local url="$1"
    echo "Checking URL: $url"
    
    # Fetch the content
    content=$(curl -s "$url")
    
    if [ -z "$content" ]; then
        echo "No content found at $url"
        return
    fi
    
    # Search for common secret patterns - expanded to include more patterns
    result=$(echo "$content" | grep -o -i -E "(aws_|aws-|-secret|_secret|-key|_key|-token|_token|bearer|authorization).{0,160}" --color=always)
    
    if [ -n "$result" ]; then
        echo "$(echo -e '\033[38;5;220m')[$url]$(echo -e '\033[0m')"
        echo "$result"
        echo "------------------------------------"
    fi
}

read -p "Press 1 to enter a URL, 2 to use a file with URLs, or 3 to crawl a website: " option

if [ "$option" -eq 1 ]; then
    read -p "Enter the URL: " url
    extract_secrets "$url"
    
elif [ "$option" -eq 2 ]; then
    read -p "Enter the path to the file with URLs: " url_file
    
    if [ ! -f "$url_file" ]; then
        echo "File not found: $url_file"
        exit 1
    fi
    
    while read -r url; do
        extract_secrets "$url"
    done < "$url_file"
    
elif [ "$option" -eq 3 ]; then
    read -p "Enter the base URL to crawl: " base_url
    
    # First, try to find all links on the page using LinkFinder if available
    if command -v linkfinder &> /dev/null; then
        echo "Using LinkFinder to discover URLs..."
        urls=$(linkfinder -i "$base_url" -d -o cli | grep -v "Running against" | sort -u)
    else
        # Fallback to using grep to find URLs if LinkFinder is not available
        echo "LinkFinder not found, using basic URL extraction..."
        page_content=$(curl -s "$base_url")
        urls=$(echo "$page_content" | grep -o -E 'https?://[^"'\''> ]+' | sort -u)
    fi
    
    # Check the base URL first
    extract_secrets "$base_url"
    
    # Check all discovered URLs
    while read -r url; do
        # Check if the URL is valid
        if [[ "$url" == http* ]]; then
            extract_secrets "$url"
        else
            # Construct full URL if it's a relative path
            if [[ "$url" == /* ]]; then
                # Extract domain from base_url
                domain=$(echo "$base_url" | grep -o -E 'https?://[^/]+')
                full_url="${domain}${url}"
            else
                full_url="${base_url}${url}"
            fi
            extract_secrets "$full_url"
        fi
    done <<< "$urls"
    
else
    echo "Invalid option selected"
    exit 1
fi
