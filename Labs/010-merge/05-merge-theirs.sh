#!/bin/bash

source _init.sh

# Ours/theirs merge strategy
echo -e "\n${YELLOW}Merge with 'theirs' strategy (via recursive):${NO_COLOR}"
git checkout main
# Reset to before merge
git reset --hard HEAD~2
# Merge with theirs (keep feature changes)
git merge feature -s recursive -X theirs -m "Merge feature with theirs strategy"
git log --oneline --graph --all

