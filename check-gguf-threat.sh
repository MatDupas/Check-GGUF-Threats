#!/bin/bash

#Author: Mathieu Dupas

# Description: 
#This script reads a gguf model file and searches for specified patterns typically associated with Jinja2 SSTI.

# Parameters:
# $1: inputFile - Path to the binary file to be analyzed.
# searchStrings (hardcoded)- Array of strings to search for in the file content.

# Example usage:
# ./check-gguf-threat.sh model.gguf

# Author: Mathieu Dupas / NBS-SYSTEM
# Date: 2024-06-11


if [ -z "$1" ]; then
    echo "Usage: $0 <model.gguf>"
    exit 1
fi

# Set inputFile and searchStrings
inputFile="$1"
searchStrings=("__subclasses__" "__builtins__") # Typical functions used in jinja2 SSTI

# Extract strings from the binary file
stringContent=$(strings "$inputFile")

for searchString in "${searchStrings[@]}"; do
    
    result=$(echo "$stringContent" | grep -i --color=always "$searchString")

    if [ -n "$result" ]; then
        echo "================================================================================"
        echo -e "[!] Warning ! \n    Found potentially dangerous content '$searchString' string in the model file!\n"
        echo -e "\t[+] Overview of the potential threat strings:\n\t$result\n"

    else
        echo "[+] Done. Did not find threat evidence in the model file."
    fi
done

