#!/bin/bash

# extract_untranslated.sh

VERSION="1.0.1"
OUTPUT_FILE="untranslated_all.txt"
DIRECTORY="."
SOURCE_LANGUAGE="en"

# Function to display help
show_help() {
    echo "Usage: $0 [OPTIONS]"
    echo "Extract untranslated text from all XLIFF files in a directory into a single file."
    echo
    echo "Options:"
    echo "  -d, --directory DIR    Specify the directory containing XLIFF files (default: current directory)"
    echo "  -o, --output FILE      Specify the output file (default: untranslated_all.txt)"
    echo "  -s, --source-lang LANG Specify the source language (default: en)"
    echo "  -h, --help             Display this help and exit"
    echo "  -v, --version          Display version information and exit"
    echo
    echo "Output format includes an AI translation prompt and is suitable for AI translation tools."
}

# Function to display version
show_version() {
    echo "extract_untranslated.sh version $VERSION"
    echo "Developed for extracting untranslated XLIFF content."
}

# Parse command-line arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -d|--directory) DIRECTORY="$2"; shift ;;
        -o|--output) OUTPUT_FILE="$2"; shift ;;
        -s|--source-lang) SOURCE_LANGUAGE="$2"; shift ;;
        -h|--help) show_help; exit 0 ;;
        -v|--version) show_version; exit 0 ;;
        *) echo "Unknown option: $1"; show_help; exit 1 ;;
    esac
    shift
done

# Check if directory exists
if [[ ! -d "$DIRECTORY" ]]; then
    echo "Error: Directory '$DIRECTORY' does not exist."
    exit 1
fi

# Clear the output file if it exists
> "$OUTPUT_FILE"

# Add AI prompt and example at the top
cat << EOF > "$OUTPUT_FILE"
# AI Translation Instructions
# Translate the 'Source' text from $SOURCE_LANGUAGE to the specified 'Language' for each entry.
# Do not translate 'QR Unveil' or 'Simple QR' - keep them as is in the 'Target' field.
# Replace '(untranslated)' with the translated text in the 'Target' field.
# Maintain the exact format of each entry, including 'Entry #', 'File', 'Language', 'ID', 'Source', 'Target', and '----------------'.
# Example:
# Entry #1
# File: ./ar.xliff
# Language: ar
# ID: Open the scanner
# Source: Open the scanner
# Target: (untranslated)
# ----------------
# Becomes:
# Entry #1
# File: ./ar.xliff
# Language: ar
# ID: Open the scanner
# Source: Open the scanner
# Target: افتح الماسح الضوئي
# ----------------
#
EOF

# Counter for unique IDs across files
entry_count=0

# Process each XLIFF file in the directory
for INPUT_FILE in "$DIRECTORY"/*.xliff; do
    if [[ -f "$INPUT_FILE" ]]; then
        echo "Processing: $INPUT_FILE"
        
        # Extract target-language from the XLIFF file
        target_language=$(grep -oP 'target-language="\K[^"]+' "$INPUT_FILE" | head -1)
        if [[ -z "$target_language" ]]; then
            target_language="unknown"
        fi

        # Read the file line by line
        while IFS= read -r line; do
            if [[ $line =~ \<trans-unit\ id=\"([^\"]*)\" ]]; then
                trans_unit_id="${BASH_REMATCH[1]}"
                trans_unit_content=""
                while IFS= read -r next_line && [[ ! $next_line =~ \</trans-unit\> ]]; do
                    trans_unit_content+="$next_line"$'\n'
                done
                trans_unit_content+="$next_line"

                # Extract source and target (if exists)
                source=$(echo "$trans_unit_content" | grep -oP '<source>\K[^<]+(?=</source>)')
                target=$(echo "$trans_unit_content" | grep -oP '<target[^>]*>\K[^<]+(?=</target>)' || echo "")

                # Skip if source is empty or if it's "QR Unveil" or "Simple QR"
                if [[ -z "$source" || "$source" == "QR Unveil" || "$source" == "Simple QR" ]]; then
                    continue
                fi

                # Check if untranslated (no target or target equals source)
                if [[ -z "$target" || "$target" == "$source" ]]; then
                    ((entry_count++))
                    echo "Entry #$entry_count" >> "$OUTPUT_FILE"
                    echo "File: $INPUT_FILE" >> "$OUTPUT_FILE"
                    echo "Language: $target_language" >> "$OUTPUT_FILE"
                    echo "ID: $trans_unit_id" >> "$OUTPUT_FILE"
                    echo "Source: $source" >> "$OUTPUT_FILE"
                    echo "Target: (untranslated)" >> "$OUTPUT_FILE"
                    echo "----------------" >> "$OUTPUT_FILE"
                fi
            fi
        done < "$INPUT_FILE"
    fi
done

if [[ $entry_count -eq 0 ]]; then
    echo "No untranslated entries found in $DIRECTORY/*.xliff" | tee -a "$OUTPUT_FILE"
else
    echo "Extracted $entry_count untranslated entries to $OUTPUT_FILE"
fi