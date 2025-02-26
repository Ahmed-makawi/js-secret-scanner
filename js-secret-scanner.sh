#!/bin/bash

read -p "Press 1 to enter a base URL or 2 to use live-urls.txt: " option

if [ "$option" -eq 1 ]; then
    read -p "Enter the base URL: " base_url

    # Step 1: Run LinkFinder to find JavaScript files
    js_files=$(linkfinder -i "$base_url" -d -o cli | grep "\.js" | grep -v "Running against" | sort -u)
    
    if [ -z "$js_files" ]; then
        exit 1
    fi

    # Step 2: Process each JavaScript file
    while read -r path; do
        # Check if the path is already an absolute URL
        if [[ "$path" == http* ]]; then
            url="$path"
        else
            url="$base_url$path"
        fi

        # Fetch the content of the JavaScript file
        content=$(curl -s "$url")
        
        if [ -z "$content" ]; then
            continue
        fi

        # Step 3: Search for sensitive patterns
        result=$(echo "$content" | grep -o -i -E "(aws_|aws-|-secret|_secret|-key|_key|-token|_token|bearer|authorization).{0,160}" --color=always)
        
        if [ -n "$result" ]; then
            echo "$(echo -e '\033[38;5;220m')[$url]$(echo -e '\033[0m') $result"
        fi
    done <<< "$js_files"

elif [ "$option" -eq 2 ]; then
    while read -r url; do
        # Step 1: Run LinkFinder to find JavaScript files
        js_files=$(linkfinder -i "$url" -d -o cli | grep "\.js" | grep -v "Running against" | sort -u)
        
        if [ -z "$js_files" ]; then
            continue
        fi

        # Step 2: Process each JavaScript file
        while read -r path; do
            # Check if the path is already an absolute URL
            if [[ "$path" == http* ]]; then
                full_url="$path"
            else
                full_url="$url$path"
            fi

            # Fetch the content of the JavaScript file
            content=$(curl -s "$full_url")
            
            if [ -z "$content" ]; then
                continue
            fi

            # Step 3: Search for sensitive patterns
            result=$(echo "$content" | grep -o -i -E "(aws_|aws-|-secret|_secret|-key|_key|-token|_token|bearer|authorization).{0,160}" --color=always)
            
            if [ -n "$result" ]; then
                echo "$(echo -e '\033[38;5;220m')[$full_url]$(echo -e '\033[0m') $result"
            fi
        done <<< "$js_files"
    done < live-urls.txt

else
    echo "Invalid option selected"
fi
