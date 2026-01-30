#!/bin/bash

# Configuration - CHANGE THESE
GITHUB_USER="SmilingBytes"
GITHUB_REPO="md2pdf"
SCRIPT_NAME="md2pdf.sh"
RAW_URL="https://raw.githubusercontent.com/$GITHUB_USER/$GITHUB_REPO/main/$SCRIPT_NAME"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}Starting installation of md2pdf...${NC}"

# 1. Create directory
INSTALL_DIR="$HOME/.config/md2pdf"
mkdir -p "$INSTALL_DIR"

# 2. Download the script
echo -e "Downloading ${SCRIPT_NAME}..."
if curl -fsSL "$RAW_URL" -o "$INSTALL_DIR/$SCRIPT_NAME"; then
    chmod +x "$INSTALL_DIR/$SCRIPT_NAME"
    echo -e "${GREEN}Successfully downloaded to $INSTALL_DIR${NC}"
else
    echo -e "${RED}Failed to download script. Please check your internet connection or URL.${NC}"
    exit 1
fi

# 3. Identify Shell and RC file
CURRENT_SHELL=$(basename "$SHELL")
RC_FILE=""

if [[ "$CURRENT_SHELL" == "zsh" ]]; then
    RC_FILE="$HOME/.zshrc"
    SOURCE_BLOCK="
# Source md2pdf script
if [[ -f \"$INSTALL_DIR/$SCRIPT_NAME\" ]]; then
    source \"$INSTALL_DIR/$SCRIPT_NAME\"
fi"
elif [[ "$CURRENT_SHELL" == "bash" ]]; then
    RC_FILE="$HOME/.bashrc"
    SOURCE_BLOCK="
# Source md2pdf script
if [[ -f \"$INSTALL_DIR/$SCRIPT_NAME\" ]]; then
    source \"$INSTALL_DIR/$SCRIPT_NAME\"
fi"
else
    echo -e "${RED}Unsupported shell: $CURRENT_SHELL. Please manually source $INSTALL_DIR/$SCRIPT_NAME${NC}"
    exit 0
fi

# 4. Add to RC file if not already there
if [[ -f "$RC_FILE" ]]; then
    if ! grep -q ".config/md2pdf" "$RC_FILE"; then
        echo -e "Adding sourcing logic to ${RC_FILE}..."
        echo "$SOURCE_BLOCK" >> "$RC_FILE"
        echo -e "${GREEN}Installation complete!${NC}"
    else
        echo -e "${BLUE}Sourcing logic already exists in $RC_FILE.${NC}"
    fi
    
    # Source the script immediately if possible
    echo -e "Sourcing ${SCRIPT_NAME} for current session..."
    source "$INSTALL_DIR/$SCRIPT_NAME"
    echo -e "${GREEN}Done! You can now use 'md2pdf'${NC}"
else
    echo -e "${RED}Config file $RC_FILE not found.${NC}"
    # Fallback: just source the script
    source "$INSTALL_DIR/$SCRIPT_NAME"
fi
