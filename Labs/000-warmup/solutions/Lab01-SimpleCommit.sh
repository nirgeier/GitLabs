#!/bin/bash

###
### Git Labs solution(s)
### Author:    github.com/nirgeier

# Clear the screen
clear

# Load the colors palette - Download the colors script
temp_file=$(mktemp)         &&  \
            curl -s https://raw.githubusercontent.com/nirgeier/labs-assets/refs/heads/main/assets/scripts/colors.sh \
            -o "$temp_file" &&  \
            source "$temp_file"

## Exercise One - Under The Hood of a Simple Commit

## Exercise
## 1. Create a new folder and initialize it as a git repo
## 2. Create a file
## 3. Stage the file
## 4. Commit the file to your local git repo
## 5. View the content of .git folder, using tree or in way you would like to
## 6. Inspect the objects in your .git/objects folder using git cat-file [-p/-t] <sha-1>.
## 7. View the content of .git/HEAD and .git/refs/heads/main what are those references?
################################
### Solution
################################

echo -e "${CYAN}✔ Cleanup ${NO_COLOR}"
rm -rf /tmp/git-lab-01

echo -e "${GREEN}✔ Step 01 ${NO_COLOR}"

echo -e "${YELLOW}  ✔ Creating a new folder ${NO_COLOR}"
mkdir   /tmp/git-lab-01
cd      /tmp/git-lab-01

echo -e "${YELLOW}  ✔ Testing if its a git repository ${NO_COLOR}"
git branch 2>&1 1>/dev/null | grep -v '^\*' | sed 's/^/\t/'

echo -e "${YELLOW}  ✔ Initializing git repository ${NO_COLOR}"
git init | grep -v '^\*' | sed 's/^/\t/'

### You should see this output
### fatal: not a git repository (or any of the parent directories): .git

echo -e "${RED}Press any key to continue...${NO_COLOR}"
read -t 5

echo -e "${GREEN}✔ Step 02 ${NO_COLOR}"

# Create a file, stage it, and commit it to your new repo
echo -e "${YELLOW}  ✔ Creating file ${NO_COLOR}"
echo 'aaa' > a.txt | grep -v '^\*' | sed 's/^/\t/'

echo -e "${GREEN}✔ Step 03 ${NO_COLOR}"
echo -e "${YELLOW}  ✔ Staging the file ${NO_COLOR}"
git add . | grep -v '^\*' | sed 's/^/\t/'
git status -s | grep -v '^\*' | sed 's/^/\t/'

echo -e "${GREEN}✔ Step 04 ${NO_COLOR}"
echo -e "${YELLOW}  ✔ Committing the file ${NO_COLOR}"
git commit -m "Initial commit" | grep -v '^\*' | sed 's/^/\t/'

echo -e "${RED}Press any key to continue...${NO_COLOR}"
read -t 5

echo -e "${GREEN}✔ Step 05 ${NO_COLOR}"
echo -e "${YELLOW}  ✔ View .git/objects  ${NO_COLOR}"
tree .git/objects | grep -v '^\*' | sed 's/^/\t/'

echo -e "${RED}Press any key to continue...${NO_COLOR}"
read -t 5

echo -e "${GREEN}✔ Step 06 ${NO_COLOR}"
echo -e "${YELLOW}  ✔ View .git/objects files (list) ${NO_COLOR}"
for file in $(find .git/objects -type f); do
    hash=$(echo $file | sed -e 's|^.git/objects/||' -e 's|/||')
    echo -e "\t${GREEN}[$hash]$(git cat-file -t $hash | grep -v '^\*' | sed 's/^/\t/')"
done

echo -e "${YELLOW}  ✔ View .git/objects content ${NO_COLOR}"
echo -e "\t${YELLOW}--------------------------------------------------------${NO_COLOR}"
for file in $(find .git/objects -type f); do
    hash=$(echo $file | sed -e 's|^.git/objects/||' -e 's|/||')
    echo -e "\t${GREEN}[$hash]${NO_COLOR}\n $(git cat-file -p $hash | grep -v '^\*' | sed 's/^/\t/')"
    echo -e "\t"
done

echo -e "${RED}Press any key to continue...${NO_COLOR}"
read -t 5

echo -e "${GREEN}✔ Step 07 ${NO_COLOR}"
echo -e "${YELLOW}  ✔ View .git/HEAD ${NO_COLOR}"
cat .git/HEAD | grep -v '^\*' | sed 's/^/\t/'

echo -e "${YELLOW}  ✔ View .git/refs/heads/$(git branch --show-current) ${NO_COLOR}"
cat .git/refs/heads/$(git branch --show-current) | grep -v '^\*' | sed 's/^/\t/'
