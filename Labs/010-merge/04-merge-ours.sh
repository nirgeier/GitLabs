#!/bin/bash

source _init.sh

# Ours/theirs merge strategy
echo -e "\n${YELLOW}Merge with 'ours' strategy:${NO_COLOR}"
git checkout main
# Reset to before merge
git reset --hard HEAD~1
# Merge with ours (keep main changes)
git merge feature -s ours -m "Merge feature with ours strategy"
git log --oneline --graph --all

