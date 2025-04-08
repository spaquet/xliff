#!/bin/bash

# extract_xliff.sh
# Script to extract .xliff files from .xcloc packages
# Usage: ./extract_xliff.sh [input_directory] [output_directory]
#   - input_directory: Directory containing .xcloc packages (default: current directory)
#   - output_directory: Directory where extracted .xliff files will be saved (default: xliff_files)
# Version: 1.1.0

VERSION="1.1.0"

# Color codes
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Display help message
show_help() {
    echo -e "${GREEN}Usage:${NC} $0 [input_directory] [output_directory]"
    echo "Extract .xliff files from .xcloc packages"
    echo
    echo -e "${YELLOW}Options:${NC}"
    echo "  -h, --help     Display this help message"
    echo "  -v, --version  Display script version"
    echo
    echo -e "${YELLOW}Arguments:${NC}"
    echo "  input_directory   Directory containing .xcloc packages (default: current directory)"
    echo "  output_directory  Directory for extracted .xliff files (default: xliff_files)"
}

# Check for help or version flags
case "$1" in
    -h|--help)
        show_help
        exit 0
        ;;
    -v|--version)
        echo -e "${GREEN}extract_xliff.sh version ${VERSION}${NC}"
        exit 0
        ;;
esac

# Default input and output directories (can be overridden with arguments)
INPUT_DIR=${1:-"."}          # Default to current directory if no argument provided
OUTPUT_DIR=${2:-"xliff_files"}  # Default output directory

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Check if input directory exists
if [ ! -d "$INPUT_DIR" ]; then
    echo -e "${RED}Error:${NC} Input directory '$INPUT_DIR' does not exist."
    exit 1
fi

# Counter for processed files
count=0

# Find all .xcloc packages and process them
echo -e "${YELLOW}Processing .xcloc packages...${NC}"
for xcloc in "$INPUT_DIR"/*.xcloc; do
    if [ -d "$xcloc" ]; then  # Check if it's a directory (package)
        echo -e "  ${GREEN}Processing:${NC} $xcloc"
        
        # Look for .xliff files inside the package
        xliff_file=$(find "$xcloc" -type f -name "*.xliff" | head -n 1)
        
        if [ -n "$xliff_file" ]; then
            # Extract the base name of the package (e.g., 'fr' from 'fr.xcloc')
            base_name=$(basename "$xcloc" .xcloc)
            
            # Copy the .xliff file to output directory with package name prefix
            cp "$xliff_file" "$OUTPUT_DIR/${base_name}.xliff"
            echo -e "    ${GREEN}Extracted:${NC} ${base_name}.xliff"
            ((count++))
        else
            echo -e "    ${YELLOW}Warning:${NC} No .xliff file found in $xcloc"
        fi
    fi
done

echo -e "${GREEN}Extraction complete.${NC} Processed ${count} .xcloc packages."