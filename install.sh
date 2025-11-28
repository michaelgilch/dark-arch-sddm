#!/bin/bash

# SDDM Theme Installation Script
# Installs dark-sddm-theme and configures SDDM to use it

set -e  # Exit on error

THEME_NAME="dark-sddm-theme"
THEME_SOURCE="./base"
THEME_DEST="/usr/share/sddm/themes/${THEME_NAME}"
SDDM_CONF_DIR="/etc/sddm.conf.d"
SDDM_CONF_FILE="${SDDM_CONF_DIR}/theme.conf"

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}Installing SDDM theme: ${THEME_NAME}${NC}"

# Check if source theme directory exists
if [ ! -d "$THEME_SOURCE" ]; then
    echo -e "${RED}Error: Source directory '${THEME_SOURCE}' not found${NC}"
    echo "Please run this script from the directory containing the 'base' folder"
    exit 1
fi

# Remove existing theme installation if present
if [ -d "$THEME_DEST" ]; then
    echo -e "${YELLOW}Removing existing theme installation...${NC}"
    sudo rm -rf "$THEME_DEST"
fi

# Create theme directory and copy files
echo "Installing theme files..."
sudo mkdir -p "$THEME_DEST"
sudo cp -r "$THEME_SOURCE"/* "$THEME_DEST/"

# Verify theme was copied
if [ ! -d "$THEME_DEST" ]; then
    echo -e "${RED}Error: Failed to copy theme files${NC}"
    exit 1
fi

echo -e "${GREEN}Theme files installed to ${THEME_DEST}${NC}"

# Create SDDM configuration directory if it doesn't exist
sudo mkdir -p "$SDDM_CONF_DIR"

# Create or update theme configuration
echo "Configuring SDDM to use ${THEME_NAME}..."

# Create new config file with theme setting
cat << EOF | sudo tee "$SDDM_CONF_FILE" > /dev/null
[Theme]
Current=${THEME_NAME}
EOF

echo -e "${GREEN}Configuration updated: ${SDDM_CONF_FILE}${NC}"

# Verify SDDM is installed
if ! command -v sddm &> /dev/null; then
    echo -e "${YELLOW}Warning: SDDM does not appear to be installed${NC}"
fi

# Check if SDDM service is enabled
if systemctl is-enabled sddm.service &> /dev/null; then
    echo -e "${GREEN}SDDM service is enabled${NC}"
    echo -e "${YELLOW}Restart required for theme to take effect${NC}"
    echo "Restart SDDM with: sudo systemctl restart sddm.service"
else
    echo -e "${YELLOW}Note: SDDM service is not enabled${NC}"
    echo "Enable with: sudo systemctl enable sddm.service"
fi

echo -e "${GREEN}Installation complete!${NC}"
exit 0
