#!/bin/bash

# Directory containing images
DIR="images/animations/coins"

# Desired width
TARGET_WIDTH=400

# Find and resize PNG images
find "$DIR" -type f -iname "*.png" -exec sips --resampleWidth "$TARGET_WIDTH" {} \;
