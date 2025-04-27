#!/bin/bash

########################################################################
### COLORS
########################################################################
# Reset
NO_COLOR='\033[0m'       # Text Reset

# Regular Colors
RED='\033[0;31m'          # Red
GREEN='\033[0;32m'        # Green

###
### This is our demo script for searching the bug
### In this demo we simply search for a string
### In real life we can do a build, check who deleted file etc. 
###

grep "Here is the bug" random1.txt

if [ "$?" -eq "0" ]; then
    echo -e "${GREEN}Text found.${NO_COLOR}"
    exit 1
else
    #echo "Text not found."
    echo -e "${RED}Text Not found.${NO_COLOR}"
    exit 0
fi

echo ""