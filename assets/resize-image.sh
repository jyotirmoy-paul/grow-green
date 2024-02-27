#!/bin/bash

# Directory containing images
DIR="images/tiles"

# Desired width
TARGET_WIDTH=1024

# Find and resize PNG images
find "$DIR" -type f -iname "*.png" -exec sips --resampleWidth "$TARGET_WIDTH" {} \;
