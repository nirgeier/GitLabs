#!/bin/bash

source _init.sh

# Fast-forward merge (only possible if no new commits on main)
echo -e "${CYAN}* Fast-forward merge:${NO_COLOR}"
git checkout main
# Reset to initial commit to allow fast-forward
GIT_MERGE_AUTOEDIT=no git reset --hard "__feature_commit__"

# Merge feature (should be fast-forward)
git merge feature --ff-only
git log --oneline --graph --all

