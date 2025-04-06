# XLIFF Tools for Xcode Localization

![GitHub release (latest by date)](https://img.shields.io/github/v/release/spaquet/xliff?style=flat-square)
![GitHub](https://img.shields.io/github/license/spaquet/xliff?style=flat-square)
![Bash](https://img.shields.io/badge/language-Bash-green?style=flat-square)

A set of bash scripts to manage `.xliff` files extraction and packaging for Xcode localization workflows.

## Overview

When developing applications for Apple platforms using Xcode, the localization process involves working with `.xcloc` packages that contain `.xliff` (XML Localization Interchange File Format) files. These scripts simplify the workflow by:

1. **Extracting** `.xliff` files from `.xcloc` packages for translation
2. **Packaging** translated `.xliff` files back into `.xcloc` packages for import into Xcode

## Scripts

### extract_xliff.sh

Extracts `.xliff` files from `.xcloc` packages for translation or editing.

```bash
./extract_xliff.sh [input_directory] [output_directory]
```

#### Parameters:
- `input_directory`: Directory containing `.xcloc` packages (default: current directory)
- `output_directory`: Directory where extracted `.xliff` files will be saved (default: `xliff_files`)

#### Example:
```bash
./extract_xliff.sh ./localizations ./extracted_translations
```

### package_xliff.sh

Packages translated `.xliff` files back into `.xcloc` packages for import into Xcode.

```bash
./package_xliff.sh [xliff_directory] [output_directory]
```

#### Parameters:
- `xliff_directory`: Directory containing translated `.xliff` files (default: `xliff_files`)
- `output_directory`: Directory where `.xcloc` packages will be created (default: `xcloc_packages`)

#### Example:
```bash
./package_xliff.sh ./translated_xliff ./packaged_translations
```

## Workflow Example

1. Export localizations from Xcode (File > Export Localizations)
2. Run `extract_xliff.sh` to extract `.xliff` files from the exported `.xcloc` packages
3. Translate or edit the extracted `.xliff` files
4. Run `package_xliff.sh` to package the translated `.xliff` files back into `.xcloc` packages
5. Import the packaged `.xcloc` files back into Xcode (File > Import Localizations)

## Options

Both scripts support the following options:

- `-h`, `--help`: Display help message
- `-v`, `--version`: Display script version

## Requirements

- Bash shell
- macOS or Linux environment

## Installation

1. Clone this repository:
```bash
git clone https://github.com/spaquet/xliff.git
```

2. Make the scripts executable:
```bash
chmod +x extract_xliff.sh package_xliff.sh
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Version History

- 1.0.0: Initial release
  - Basic extraction and packaging functionality
  - Help and version options
  - Default directory paths
