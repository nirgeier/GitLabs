#!/bin/bash

### This script provides a menu to select and demonstrate various git log search capabilities.
### Users can choose specific showcases or run all of them.

### Create repository with commits and files using the utility functions
source "../../_utils/colors.sh"
source "../../_utils/utils.sh"

# CLear any previous repository
rm -rf /tmp/git-lab-demo

# Generate demo repository
generate_repository 50 10

# Move to the demo repository
cd /tmp/git-lab-demo

# Search for text in the repository's commit history
search_text_in_commits() {
    local search_text="$1"
    echo -e "${CYAN}Searching for text '${YELLOW}$search_text${CYAN}' in commit messages...${NC}"
    print_separator
    git log --all --grep="$search_text" --pretty=format:"%h - %an, %ar : %s"
    print_separator
    echo ""
}   

# Search for text in code changes using git log -S (Pickaxe)
search_text_in_code_changes() {
    local search_text="$1"
    echo -e "${CYAN}Searching for text '${YELLOW}$search_text${CYAN}' in code changes (diffs)...${NC}"
    print_separator
    echo -e "${GREEN}Command: git log -S \"$search_text\" --oneline -p${NC}"
    echo "This shows commits where the string was added or removed in the code."
    echo ""
    git log -S "$search_text" --oneline -p | head -50
    print_separator
    echo ""
}

# Function to print a visual separator line
print_separator() {
    echo -e "${YELLOW}===========================================${NC}"
}

# Define colors if not defined by the sourced script
if [ -z "$RED" ]; then
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    BLUE='\033[0;34m'
    MAGENTA='\033[0;35m'
    CYAN='\033[0;36m'
    WHITE='\033[1;37m'
    NC='\033[0m' # No Color
fi

# Clear the screen for a clean output
clear

# Main menu function
show_menu() {
    echo -e "${BLUE}Git Log Search Showcase Menu${NC}"
    print_separator
    echo "Choose a search type to demonstrate:"
    echo -e "${GREEN}1)${NC} Search in Commit Messages (--grep)"
    echo -e "${GREEN}2)${NC} Search in Code Changes (-S Pickaxe)"
    echo -e "${RED}0)${NC} Exit"
    print_separator
    echo -n "Enter your choice [0-2]: "
}

# Main script logic
while true; do
    show_menu
    read choice
    case $choice in
        1) 
            echo -e "${YELLOW}Enter text to search in commit messages:${NC}"
            read search_text
            search_text_in_commits "$search_text"
            ;;
        2) 
            echo -e "${YELLOW}Enter text to search in code changes:${NC}"
            read search_text
            search_text_in_code_changes "$search_text"
            ;;
        0) echo -e "${RED}Exiting...${NC}"; exit 0 ;;
        *) echo -e "${RED}Invalid choice. Please enter 0-2.${NC}" ;;
    esac
    echo ""
    echo -e "${YELLOW}Press Enter to continue...${NC}"
    read
    clear
done
