#!/bin/bash

source _init.sh

# No fast-forward merge
echo -e "\n${YELLOW}No fast-forward merge (--no-ff):${NO_COLOR}"
git checkout main
# Reset to before merge
git reset --hard HEAD~1 
# Merge with --no-ff
git merge feature --no-ff -m "Merge feature with --no-ff"
git log --oneline --graph --all


