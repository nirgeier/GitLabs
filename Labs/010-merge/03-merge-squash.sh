#!/bin/bash

source _init.sh

# Squash merge
echo -e "\n${YELLOW}Squash merge (--squash):${NO_COLOR}"
git checkout main
# Reset to before merge
git reset --hard HEAD~1
# Merge with --squash
git merge feature --squash
git commit -m "Squash merge feature"
git log --oneline --graph --all


