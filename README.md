# js-secret-scanner.sh

A simple yet powerful tool to scan websites for exposed secrets in JavaScript files.

## Overview

This tool scans websites for JavaScript files and searches for potential secrets, API keys, tokens, and other sensitive information that might be accidentally exposed. It can operate on a single URL or process multiple URLs from a file.


![Untitled](https://github.com/user-attachments/assets/c7b2956b-77a8-4567-a9c9-a71ff944f66f)


## Features

- Automatically discovers JavaScript files using LinkFinder
- Analyzes JavaScript content for potential API keys, tokens, and secrets
- Supports single URL or batch scanning via a file
- Color-coded output for easy identification of issues
- Customizable pattern matching

## Requirements

- Bash shell environment
- Python packages:
  
    jsbeautifier (pip install jsbeautifier)
  
    requests (pip install requests)
- LinkFinder (https://github.com/GerbenJavado/LinkFinder)

## Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/Ahmed-makawi/js-secret-scanner.git
   cd js-secret-scanner
   pip install jsbeautifier
   ```

2. Install LinkFinder:
   ```bash
   git clone https://github.com/GerbenJavado/LinkFinder.git
   cd LinkFinder
   pip install -r requirements.txt
   python setup.py install
   cd ..
   ```

3. Make the script executable:
   ```bash
   chmod +x js-secret-scanner.sh
   ```

## Usage

### Scanning a Single Website

```bash
./js-secret-scanner.sh
```

When prompted, select option 1 and enter the base URL of the website you want to scan.

### Scanning Multiple Websites

1. Create a file named `live-urls.txt` with one URL per line.
2. Run the script:
   ```bash
   ./js-secret-scanner.sh
   ```
3. When prompted, select option 2.

## How It Works

1. The script uses LinkFinder to discover JavaScript files on the target website
2. It then downloads each JavaScript file using curl
3. Finally, it searches for patterns that might indicate exposed secrets using grep

## Pattern Detection

The script currently looks for the following patterns:
- AWS related keys (aws_, aws-)
- Secret keys (-secret, _secret)
- API keys (-key, _key)
- Authentication tokens (-token, _token)
- Bearer tokens (bearer)
- Authorization strings (authorization)

## Customization

To modify the patterns being searched, edit the following line in the script:
```bash
grep -o -i -E "(aws_|aws-|-secret|_secret|-key|_key|-token|_token|bearer|authorization).{0,160}"
```

## Considerations

- Always ensure you have permission to scan the target websites
- This tool is designed for security professionals, penetration testers, and system administrators to audit their own assets
- Use responsibly and ethically

