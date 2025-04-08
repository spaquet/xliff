#!/bin/bash

# package_xliff.sh
# Script to package .xliff files back into .xcloc packages
# Usage: ./package_xliff.sh [xliff_directory] [output_directory]
#   - xliff_directory: Directory containing .xliff files (default: xliff_files)
#   - output_directory: Directory where .xcloc packages will be created (default: xcloc_packages)
# Version: 1.1.0

VERSION="1.1.0"

# Color codes
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Display help message
show_help() {
    echo -e "${GREEN}Usage:${NC} $0 [xliff_directory] [output_directory]"
    echo "Package .xliff files into .xcloc packages"
    echo
    echo -e "${YELLOW}Options:${NC}"
    echo "  -h, --help     Display this help message"
    echo "  -v, --version  Display script version"
    echo
    echo -e "${YELLOW}Arguments:${NC}"
    echo "  xliff_directory   Directory containing .xliff files (default: xliff_files)"
    echo "  output_directory  Directory for created .xcloc packages (default: xcloc_packages)"
}

# Check for help or version flags
case "$1" in
    -h|--help)
        show_help
        exit 0
        ;;
    -v|--version)
        echo -e "${GREEN}package_xliff.sh version ${VERSION}${NC}"
        exit 0
        ;;
esac

# Default input and output directories (can be overridden with arguments)
XLIFF_DIR=${1:-"xliff_files"}  # Directory with translated .xliff files
OUTPUT_DIR=${2:-"xcloc_packages"}  # Directory for recreated .xcloc packages

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Check if input directory exists
if [ ! -d "$XLIFF_DIR" ]; then
    echo -e "${RED}Error:${NC} Input directory '$XLIFF_DIR' does not exist."
    exit 1
fi

# Counter for processed files
count=0

# Process each .xliff file
echo -e "${YELLOW}Processing .xliff files...${NC}"
for xliff in "$XLIFF_DIR"/*.xliff; do
    if [ -f "$xliff" ]; then  # Check if it's a file
        echo -e "  ${GREEN}Processing:${NC} $xliff"
        
        # Extract the language code from the filename (e.g., 'fr' from 'fr.xliff')
        base_name=$(basename "$xliff" .xliff)
        
        # Create the .xcloc package directory
        package_dir="$OUTPUT_DIR/${base_name}.xcloc"
        mkdir -p "$package_dir/Localized Contents"
        
        # Copy the .xliff file into the package
        cp "$xliff" "$package_dir/Localized Contents/${base_name}.xliff"
        echo -e "    ${GREEN}Packaged:${NC} ${base_name}.xcloc"
        ((count++))
    fi
done

echo -e "${GREEN}Packaging complete.${NC} Processed ${count} .xliff files."