#!/bin/bash

# ===============================
# 00-find_deleted_file.sh
# Demo: Randomly add and delete files in a git repo
# ===============================

# Clear the screen
clear
# Set up script directory
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# Number of commits and files
NUMBER_OF_COMMITS=50
NUMBER_OF_FILES=3

# Load color and utils scripts
ROOT_FOLDER=$(git rev-parse --show-toplevel)
source ${ROOT_FOLDER}/_utils/colors.sh
source ${ROOT_FOLDER}/_utils/utils.sh

echo -e "${CYAN}* This demo will create a new git repository and randomly add files named ${YELLOW}file1.txt${CYAN} to ${YELLOW}file${NUMBER_OF_FILES}.txt${CYAN}.${NO_COLOR}"
echo -e "${YELLOW}* Each commit will either add, delete, or modify a file randomly to the repository.${NO_COLOR}"
echo -e "${GREEN}* You will see a progress bar as the commits are created.${NO_COLOR}"
echo -e "${PURPLE}* This demo will help you understand how to find deleted files in git logs.${NO_COLOR}"
echo -e ""

echo -e "${RED}* Press Enter to start the demo...${NO_COLOR}"
read -r

echo -e "${YELLOW}* Initializing repo with $NUMBER_OF_COMMITS commits...${NO_COLOR}"
generate_repository $NUMBER_OF_COMMITS $NUMBER_OF_FILES

# Seed random
RANDOM_SEED=$(date +%s)
RANDOM=$RANDOM_SEED

echo -e "\n${GREEN}* Demo repository created with $NUMBER_OF_COMMITS commits.${NO_COLOR}"
echo -e "${CYAN}* Some files were randomly added and deleted during the process.${NO_COLOR}"
echo -e "${PURPLE}* Press Enter to view the demo...${NO_COLOR}"
read -r

# Function to prompt user and show commit history
show_commit_history_menu() {
    while true; do
        echo -e "${CYAN}* Please select a file to view its commit history:${NO_COLOR}"
        for index in $(seq 1 $NUMBER_OF_FILES); do
            echo -e "  ${GREEN}$index] ${YELLOW}file${index}.txt${NO_COLOR}"
        done
        echo -e "  ${RED}4] Exit${NO_COLOR}"

        read -p "Enter the file number (1-$NUMBER_OF_FILES) or 4 to Exit: " file_choice

        if [[ "$file_choice" == "4" ]]; then
            echo -e "${PURPLE}Exiting. Thank you!${NO_COLOR}"
            break
        fi

        # Validate input
        if ! [[ "$file_choice" =~ ^[1-3]$ ]] || [ "$file_choice" -lt 1 ] || [ "$file_choice" -gt $NUMBER_OF_FILES ]; then
            echo -e "${RED}Invalid selection. Please try again.${NO_COLOR}"
            continue
        fi

        selected_file="file${file_choice}.txt"
        echo -e "${CYAN}* Showing commit history for ${YELLOW}${selected_file}${NO_COLOR} ${PURPLE}[git log -- $selected_file]${NO_COLOR}"
        # Show git log and collect commit lines and hashes (POSIX compatible)
        git log --oneline --graph --decorate --color=always -- "$selected_file"
        echo -e "${CYAN}* Press Enter to view detailed commit changes...${NO_COLOR}"
        read -r

        commit_lines=()
        commit_hashes=()
        while IFS= read -r line; do
            commit_lines+=("$line")
        done < <(git log --oneline --graph --decorate --color=always -- "$selected_file")

        while IFS= read -r hash; do
            commit_hashes+=("$hash")
        done < <(git log --oneline -- "$selected_file" | awk '{print $1}')

        # Print the log output
        i=0
        for line in "${commit_lines[@]}"; do
            echo -e "$line"
            if [[ -n "${commit_hashes[$i]}" ]]; then
                echo -e "${YELLOW}--- Changed made in commit ${commit_hashes[$i]}${NO_COLOR}"
                git whatchanged --oneline --color=always -1 "${commit_hashes[$i]}" -- "$selected_file"
                echo -e "${CYAN}---------------------------------------------${NO_COLOR}"
            fi
            i=$((i+1))
        done

        echo -e "${PURPLE}* Press Enter to return to the menu...${NO_COLOR}"
        read -r
    done
}

# Call the menu function
show_commit_history_menu


