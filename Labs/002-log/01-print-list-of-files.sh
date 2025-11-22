#!/bin/bash

### This script lists all the files changed in each commit
### in the current branch, along with their status.
### It uses the git log command to get the commit history
### and the git show command to get the details of each commit.

# Clear the screen
clear
# Print a separator line
print_separator() {
    echo "============================================"
}

# Get all log entries and process each one
git log --pretty=format:"%h|%gd|%gs" | while IFS='|' read -r hash ref message; do
    print_separator
    echo "Commit Hash: $hash"
    echo "Ref: $ref"
    echo "Message: $message"
    echo ""
    echo "Files changed:"
    
    # Get list of changed files with their status
    git show --name-status "$hash" | grep -E '^[ACDMRTUX]' | while read -r line; do
        status=$(echo "$line" | cut -f1)
        file=$(echo "$line" | cut -f2-)
        
        # Convert status code to readable text
        case $status in
            A) status="Added     ";;
            C) status="Copied    ";;
            D) status="Deleted   ";;
            M) status="Modified  ";;
            R) status="Renamed   ";;
            T) status="Type Changed";;
            U) status="Unmerged  ";;
            X) status="Unknown   ";;
        esac
        
        echo "  $status: $file"
    done
    
    print_separator
    echo ""
done
