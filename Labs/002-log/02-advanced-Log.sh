#!/bin/bash

### This script provides a menu to select and demonstrate various git log usage cases.
### Users can choose specific showcases or run all of them.

# Source color utilities
source "../../_utils/colors.sh"
source "../../_utils/utils.sh"

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

# Function to generate demo repository
generate_demo_repo() {
    echo -e "${CYAN}Generating demo repository for git log showcases...${NC}"
    generate_repository 50 10  # Generate 50 commits with up to 10 files
    cd /tmp/git-lab-demo
    echo -e "${GREEN}Demo repository created in /tmp/git-lab-demo${NC}"
    echo -e "${YELLOW}Press Enter to continue...${NC}"
    read
}

# Function to check if we're in a git repository
check_git_repo() {
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        echo -e "${RED}Not in a git repository. Please generate a demo repository first.${NC}"
        echo -e "${YELLOW}Press Enter to return to menu...${NC}"
        read
        return 1
    fi
    return 0
}

# Function to print a visual separator line
print_separator() {
    echo -e "${YELLOW}============================================${NC}"
}

# Function to demonstrate git log graph view
show_log_graph() {
    echo -e "${CYAN}Cool Use Case 1: Git Log Graph View${NC}"
    print_separator
    echo "This shows a graphical representation of the commit history:"
    echo -e "${GREEN}Command: git log --graph --oneline --all${NC}"
    echo ""
    git log --graph --oneline --all | head -20
    print_separator
    echo ""
}

# Function to show author statistics
show_author_stats() {
    echo -e "${CYAN}Cool Use Case 2: Author Statistics${NC}"
    print_separator
    echo "This shows commit counts by author:"
    echo -e "${GREEN}Command: git shortlog -sn${NC}"
    echo ""
    git shortlog -sn
    print_separator
    echo ""
}

# Function to show commits with patches
show_commits_with_patches() {
    echo -e "${CYAN}Cool Use Case 3: Commits with Patches${NC}"
    print_separator
    echo "This shows the last 3 commits with full patches:"
    echo -e "${GREEN}Command: git log -p -3${NC}"
    echo ""
    git log -p -3 | head -50
    print_separator
    echo ""
}

# Function to show merge commits only
show_merge_commits() {
    echo -e "${CYAN}Cool Use Case 4: Merge Commits Only${NC}"
    print_separator
    echo "This shows only merge commits:"
    echo -e "${GREEN}Command: git log --merges --oneline${NC}"
    echo ""
    git log --merges --oneline | head -10
    print_separator
    echo ""
}

# Function to show commits with relative dates
show_relative_dates() {
    echo -e "${CYAN}Cool Use Case 5: Commits with Relative Dates${NC}"
    print_separator
    echo "This shows commits with human-readable relative dates:"
    echo -e "${GREEN}Command: git log --relative-date --oneline${NC}"
    echo ""
    git log --relative-date --oneline | head -10
    print_separator
    echo ""
}

# Function to show file history with renames
show_file_history() {
    echo -e "${CYAN}Cool Use Case 6: File History with Renames${NC}"
    print_separator
    echo "This shows the history of a specific file, following renames:"
    echo -e "${GREEN}Command: git log --follow --oneline -- README.md${NC}"
    echo "(Assuming README.md exists; replace with any file)"
    echo ""
    if [ -f "README.md" ]; then
        git log --follow --oneline -- README.md | head -10
    else
        echo -e "${RED}README.md not found. Try: git log --follow --oneline -- <filename>${NC}"
    fi
    print_separator
    echo ""
}

# Function to show commits by date range
show_date_range() {
    echo -e "${CYAN}Cool Use Case 7: Commits in Date Range${NC}"
    print_separator
    echo "This shows commits from the last month:"
    echo -e "${GREEN}Command: git log --since='1 month ago' --oneline${NC}"
    echo ""
    git log --since='1 month ago' --oneline | head -10
    print_separator
    echo ""
}

# Function to show custom formatted log
show_custom_format() {
    echo -e "${CYAN}Cool Use Case 8: Custom Formatted Log${NC}"
    print_separator
    echo "This shows commits with custom formatting:"
    echo -e "${GREEN}Command: git log --pretty=format:'%h - %an, %ar : %s' --stat${NC}"
    echo ""
    git log --pretty=format:'%h - %an, %ar : %s' --stat | head -20
    print_separator
    echo ""
}

# Function to show original use case: files changed in each commit
show_original_use_case() {
    echo -e "${CYAN}Original Use Case: Files Changed in Each Commit${NC}"
    print_separator
    # Main logic: Get all log entries and process each commit
    # git log --pretty=format:"%h|%gd|%gs" : 
    #   - %h: abbreviated commit hash
    #   - %gd: ref name (branch/tag)
    #   - %gs: subject (commit message)
    # The output is piped to a while loop that reads each line
    git log --pretty=format:"%h|%gd|%gs" | while IFS='|' read -r hash ref message; do
        # Print separator and commit information
        print_separator
        echo -e "${BLUE}Commit Hash: ${WHITE}$hash${NC}"
        echo -e "${BLUE}Ref: ${WHITE}$ref${NC}"
        echo -e "${BLUE}Message: ${WHITE}$message${NC}"
        echo ""
        echo "Files changed:"
        
        # For each commit, get the list of changed files with their status
        # git show --name-status: shows names and status of changed files
        # grep -E '^[ACDMRTUX]': filter only valid status codes
        git show --name-status "$hash" | grep -E '^[ACDMRTUX]' | while read -r line; do
            # Extract status (first character) and filename (rest of line)
            status=$(echo "$line" | cut -f1)
            file=$(echo "$line" | cut -f2-)
            
            # Convert single-letter status codes to readable descriptions
            case $status in
                A) status="${GREEN}Added     ${NC}";;      # File was added
                C) status="${BLUE}Copied    ${NC}";;      # File was copied
                D) status="${RED}Deleted   ${NC}";;      # File was deleted
                M) status="${YELLOW}Modified  ${NC}";;      # File was modified
                R) status="${MAGENTA}Renamed   ${NC}";;      # File was renamed
                T) status="${CYAN}Type Changed${NC}";;    # File type changed
                U) status="${RED}Unmerged  ${NC}";;      # File has merge conflicts
                X) status="${WHITE}Unknown   ${NC}";;      # Unknown status
            esac
            
            # Print the formatted status and filename
            echo "  $status: $file"
        done
        
        # Print separator and blank line for readability
        print_separator
        echo ""
    done
}

# Function to run all showcases
run_all_showcases() {
    if ! check_git_repo; then
        return
    fi
    echo -e "${MAGENTA}Running all showcases...${NC}"
    echo ""
    show_original_use_case
    show_log_graph
    show_author_stats
    show_commits_with_patches
    show_merge_commits
    show_relative_dates
    show_file_history
    show_date_range
    show_custom_format
    echo -e "${GREEN}All showcases completed!${NC}"
}

# Main menu function
show_menu() {
    echo -e "${BLUE}Git Log Showcase Menu${NC}"
    print_separator
    echo "Choose a showcase to run:"
    echo -e "${GREEN}1)${NC} Generate Demo Repository"
    echo -e "${GREEN}2)${NC} Original: Files Changed in Each Commit"
    echo -e "${GREEN}3)${NC} Graph View"
    echo -e "${GREEN}4)${NC} Author Statistics"
    echo -e "${GREEN}5)${NC} Commits with Patches"
    echo -e "${GREEN}6)${NC} Merge Commits Only"
    echo -e "${GREEN}7)${NC} Relative Dates"
    echo -e "${GREEN}8)${NC} File History with Renames"
    echo -e "${GREEN}9)${NC} Date Range"
    echo -e "${GREEN}10)${NC} Custom Formatted Log"
    echo -e "${GREEN}11)${NC} Run All Showcases"
    echo -e "${RED}0)${NC} Exit"
    print_separator
    echo -n "Enter your choice [0-11]: "
}

# Main script logic
while true; do
    show_menu
    read choice
    case $choice in
        1) generate_demo_repo ;;
        2) check_git_repo && show_original_use_case ;;
        3) check_git_repo && show_log_graph ;;
        4) check_git_repo && show_author_stats ;;
        5) check_git_repo && show_commits_with_patches ;;
        6) check_git_repo && show_merge_commits ;;
        7) check_git_repo && show_relative_dates ;;
        8) check_git_repo && show_file_history ;;
        9) check_git_repo && show_date_range ;;
        10) check_git_repo && show_custom_format ;;
        11) check_git_repo && run_all_showcases ;;
        0) echo -e "${RED}Exiting...${NC}"; exit 0 ;;
        *) echo -e "${RED}Invalid choice. Please enter 0-11.${NC}" ;;
    esac
    echo ""
    echo -e "${YELLOW}Press Enter to continue...${NC}"
    read
    clear
done
