#!/bin/bash

###
### Git Labs solution(s)
### Author:    github.com/nirgeier

DEMO_FILE_NAME=file1.txt
## For MacOs you need to install expect for spawn
## brew install expect

# Clear the screen
clear

# Load the colors palette - Download the colors script
temp_file=$(mktemp)         &&  \
            curl -s https://raw.githubusercontent.com/nirgeier/labs-assets/refs/heads/main/assets/scripts/colors.sh \
            -o "$temp_file" &&  \
            source "$temp_file"

## Exercise 02 - 3 States 
### 1. Create a new repository and Initialize it with few files and commits ([Lab01](./Lab01-SimpleCommit.md))
### 2. Create and and new files to the staging area
### 3. Use `git ls-files -s` to view the contents of the staging area.
### 4. Make a change and now stage it interactively (`git add -p`).
### 5. Use any command you know to "undo" your changes and revert to the committed file

################################
### Solution
################################

echo -e "${CYAN}✔ Cleanup ${NO_COLOR}"
rm -rf /tmp/git-lab-02

echo -e "${GREEN}✔ Step 01 ${NO_COLOR}"

echo -e "${YELLOW}  ✔ Creating a new folder ${NO_COLOR}"
mkdir   /tmp/git-lab-02
cd      /tmp/git-lab-02
# Create the folder for our repo
mkdir -p /tmp/git-lab-02

# Switch to that folder
cd /tmp/git-lab-02

# Init the repository
git init -q

# Add files and commit
echo -e "${YELLOW}  ✔ Adding and committing content ${NO_COLOR}"
for i in {1..5}; 
do 
  echo "Random text... $RANDOM" > file$i.txt; 
  git add . && git commit -q -m"Bug Fix #$RANDOM" 
done

# Show log
echo -e "${YELLOW}  ✔ Show current log ${NO_COLOR}"
echo -e ""
git log --oneline --decorate --graph --all
echo -e ""

echo -e "${RED}Press any key to continue...${NO_COLOR}"
read -t 5

echo -e "${GREEN}✔ Step 02 ${NO_COLOR}"
echo -e "${YELLOW}  ✔ Creating file(s) and adding it to the stage areas ${NO_COLOR}"
echo 'ccc' > c.txt | grep -v '^\*' | sed 's/^/\t/'

echo -e "${YELLOW}  ✔ Staging file ${CYAN}[$DEMO_FILE_NAME]${NO_COLOR}"
git add $DEMO_FILE_NAME

echo -e "${GREEN}✔ Step 03 ${NO_COLOR}"
echo -e "${YELLOW}  ✔ View the staging area ${CYAN}[git status] ${NO_COLOR}"
git status | grep -v '^\*' | sed 's/^/\t/'

echo -e "${GREEN}✔ Step 04 ${NO_COLOR}"
echo -e "${YELLOW}  ✔ View the staging content ${CYAN}[git ls-files -s] ${NO_COLOR}"
git ls-files -s | grep -v '^\*' | sed 's/^/\t/'

echo -e "${RED}Press any key to continue...${NO_COLOR}"
read -t 5

echo -e "${GREEN}✔ Step 05 ${NO_COLOR}"
echo -e "${YELLOW}  ✔ Adding content to existing file ${NO_COLOR}"

# "update" the content of your files
# by adding first line and last line
# Create a temporary file
temp_file=$(mktemp)
echo "This is new first line" > "$temp_file"
cat $DEMO_FILE_NAME >> "$temp_file"
echo "This is new last line" >> "$temp_file"
sleep 1
mv $temp_file $DEMO_FILE_NAME

echo -e "${YELLOW}  ✔ View content of existing file ${NO_COLOR}"
echo -e ""
cat $DEMO_FILE_NAME | grep -v '^\*' | sed 's/^/\t/'
echo -e ""

echo -e "${YELLOW}  ✔ Adding file iteratively ${CYAN}[git app -p] ${NO_COLOR}"
echo -e "${RED}  ✔ Accepting fist line, ignoring second line ${CYAN}[git app -p] ${NO_COLOR}"

# Sends s, y, n in sequence
# Install expect if not already installed
# For Ubuntu/Debian: apt-get install expect
# For macOS: brew install expect

expect << EOF
spawn git add -p $DEMO_FILE_NAME
expect "Stage this hunk"
send "s\r"
expect "Stage this hunk"
send "y\r"
expect "Stage this hunk"
send "n\r"
expect eof
EOF

echo -e "${YELLOW}  ✔ View staging area  ${NO_COLOR}"
git status | grep -v '^\*' | sed 's/^/\t/'

echo -e "${YELLOW}  ✔ View diff ${CYAN}[git diff --staged] ${NO_COLOR}"
git diff --staged $DEMO_FILE_NAME | grep -v '^\*' | sed 's/^/\t/'

echo -e "${RED}Press any key to continue...${NO_COLOR}"
read -t 5

echo -e "${GREEN}✔ Step 06 ${NO_COLOR}"
echo -e "${YELLOW}  ✔ "Undo" changes ${NO_COLOR}"
git restore $DEMO_FILE_NAME 

echo -e "${YELLOW}  ✔ View content of existing file after undo ${NO_COLOR}"
cat $DEMO_FILE_NAME
