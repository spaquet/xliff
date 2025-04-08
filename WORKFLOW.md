# Localization Workflow

## Overview

This document describes the workflow for extracting localization packages from Xcode, translating them using external tools, and reimporting them into Xcode.

## Step 1: Extracting Localization Packages from Xcode

To extract localization packages from Xcode, follow these steps:

1. Open your Xcode project and go to **Editor** > **Export for Localization...**
2. Choose the languages you want to export and select a location to save the packages
3. Xcode will create a `.xcloc` package for each language, containing the localization files

## Step 2: Extracting XLIFF Files from Localization Packages

To extract XLIFF files from the localization packages, you can use the `extract_xliff.sh` script:

1. Run the script with the input directory containing the `.xcloc` packages and the output directory where you want to save the XLIFF files
2. The script will extract the XLIFF files from each package and save them in the output directory

## Step 3: Translating XLIFF Files

To translate the XLIFF files, you can use external tools such as Claude, Meta AI, or Grok. These tools can be used to translate the XLIFF files and generate new translations.

## Step 4: Packaging XLIFF Files Back into Localization Packages

To package the translated XLIFF files back into localization packages, you can use the `package_xliff.sh` script:

1. Run the script with the input directory containing the translated XLIFF files and the output directory where you want to save the packaged localization files
2. The script will package the XLIFF files back into `.xcloc` packages

## Step 5: Reimporting Localization Packages into Xcode

To reimport the localization packages into Xcode, follow these steps:

1. Go to **Editor** > **Import Localizations...**
2. Select the `.xcloc` packages you want to import
3. Xcode will import the localization files and update your project

## Automating the Workflow with GitHub Actions

To automate the workflow, you can create a GitHub action that runs the `extract_xliff.sh` and `package_xliff.sh` scripts. Here's an example workflow file:

```yaml
name: Localization Workflow

on:
  push:
    branches:
      - main

jobs:
  localization:
    runs-on: macos-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v2

      - name: Extract XLIFF files
        run: |
          ./extract_xliff.sh input_directory output_directory

      - name: Translate XLIFF files
        run: |
          # Use your preferred translation tool here
          # For example, you can use Claude, Meta AI, or Grok

      - name: Package XLIFF files
        run: |
          ./package_xliff.sh input_directory output_directory

      - name: Commit and push changes
        run: |
          git add .
          git commit -m "Updated localization files"
          git push origin main
```

This workflow file assumes you have the `extract_xliff.sh` and `package_xliff.sh` scripts in the root of your repository. You'll need to modify the script paths and the translation tool to fit your specific use case.

By automating the workflow with GitHub actions, you can ensure that your localization files are always up-to-date and consistent across your project.