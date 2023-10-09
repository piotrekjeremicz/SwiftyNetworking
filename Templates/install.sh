#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

TEMPLATES_DIR="$HOME/Library/Developer/Xcode/Templates/"
mkdir -p "$TEMPLATES_DIR"

cp -r "$SCRIPT_DIR"/*.xctemplate "$TEMPLATES_DIR"

echo "The template installation was successful!"

