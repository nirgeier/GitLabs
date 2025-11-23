#!/bin/bash

# This script demonstrates Git filter-repo for repository history rewriting by removing files, extracting subdirectories, and cleaning sensitive data.

clear

# Load the colors script
ROOT_FOLDER=$(git rev-parse --show-toplevel)
source ${ROOT_FOLDER}/_utils/colors.sh
source ${ROOT_FOLDER}/_utils/utils.sh

echo -e "${CYAN}=== Git Filter-Repo Demo ===${NO_COLOR}"
echo -e ""

# Check if git-filter-repo is installed
if ! command -v git-filter-repo &> /dev/null; then
    echo -e "${RED}* git-filter-repo not found${NO_COLOR}"
    echo -e "${YELLOW}* Installation instructions:${NO_COLOR}"
    echo -e "  macOS: ${PURPLE}brew install git-filter-repo${NO_COLOR}"
    echo -e "  pip:   ${PURPLE}pip3 install git-filter-repo${NO_COLOR}"
    echo -e "  Manual: ${PURPLE}wget https://raw.githubusercontent.com/newren/git-filter-repo/main/git-filter-repo${NO_COLOR}"
    echo -e ""
    echo -e "${CYAN}* This demo will show the commands but requires git-filter-repo to execute${NO_COLOR}"
    DEMO_MODE=true
else
    echo -e "${GREEN}* git-filter-repo is installed${NO_COLOR}"
    DEMO_MODE=false
fi

echo -e ""
echo -e "${RED}>>> Press any key to continue${NO_COLOR}"
read -t 600 -n 1

# Create temporary directory for demo
DEMO_DIR="/tmp/git-filter-repo-demo"
rm -rf $DEMO_DIR
mkdir -p $DEMO_DIR
cd $DEMO_DIR

# Create source repository
echo -e ""
echo -e "${CYAN}* Creating demo repository${NO_COLOR}"
mkdir original
cd original
git init --quiet

# Create directory structure
mkdir -p src docs secrets config
echo "# Application" > src/app.js
echo "# Documentation" > docs/README.md
echo "PASSWORD=secret123" > secrets/credentials.txt
echo "API_KEY=abc123xyz" > secrets/api-keys.txt
echo "# Config" > config/settings.json

git add .
git commit -m "Initial commit" --quiet

# Add more commits
for i in {2..5}; do
    echo "Update $i" >> src/app.js
    echo "Doc update $i" >> docs/README.md
    git add .
    git commit -m "Update $i" --quiet
done

# Add sensitive data in middle of history
echo "ADMIN_PASSWORD=admin123" >> secrets/credentials.txt
git add secrets/credentials.txt
git commit -m "Add admin credentials" --quiet

for i in {6..8}; do
    echo "Update $i" >> src/app.js
    git add .
    git commit -m "Update $i" --quiet
done

echo -e "${GREEN}* Repository created with 9 commits${NO_COLOR}"
echo -e "${PURPLE}  $ git log --oneline${NO_COLOR}"
git log --oneline

echo -e ""
echo -e "${CYAN}* Repository structure:${NO_COLOR}"
echo -e "${PURPLE}  $ find . -type f | grep -v .git${NO_COLOR}"
find . -type f | grep -v .git | sort

echo -e ""
echo -e "${RED}>>> Press any key to demonstrate file removal${NO_COLOR}"
read -t 600 -n 1

# Demonstrate removing secrets folder
echo -e ""
echo -e "${YELLOW}=== Remove Secrets Folder from History ===${NO_COLOR}"
cd $DEMO_DIR

if [ "$DEMO_MODE" = false ]; then
    echo -e "${CYAN}* Cloning repository for filtering${NO_COLOR}"
    git clone original cleaned-repo --quiet
    cd cleaned-repo
    
    echo -e "${CYAN}* Removing secrets/ from entire history${NO_COLOR}"
    echo -e "${PURPLE}  $ git filter-repo --path secrets/ --invert-paths --force${NO_COLOR}"
    git filter-repo --path secrets/ --invert-paths --force
    
    echo -e "${GREEN}* Secrets removed from history${NO_COLOR}"
    echo -e "${CYAN}* Updated structure:${NO_COLOR}"
    echo -e "${PURPLE}  $ find . -type f | grep -v .git${NO_COLOR}"
    find . -type f | grep -v .git | sort
    
    echo -e ""
    echo -e "${CYAN}* Commit history unchanged:${NO_COLOR}"
    echo -e "${PURPLE}  $ git log --oneline${NO_COLOR}"
    git log --oneline
else
    echo -e "${YELLOW}* Command to remove secrets/ from history:${NO_COLOR}"
    echo -e "${PURPLE}  $ git clone original cleaned-repo${NO_COLOR}"
    echo -e "${PURPLE}  $ cd cleaned-repo${NO_COLOR}"
    echo -e "${PURPLE}  $ git filter-repo --path secrets/ --invert-paths --force${NO_COLOR}"
fi

echo -e ""
echo -e "${RED}>>> Press any key to demonstrate subdirectory extraction${NO_COLOR}"
read -t 600 -n 1

# Extract subdirectory
echo -e ""
echo -e "${YELLOW}=== Extract Subdirectory as New Repo ===${NO_COLOR}"
cd $DEMO_DIR

if [ "$DEMO_MODE" = false ]; then
    echo -e "${CYAN}* Cloning repository${NO_COLOR}"
    git clone original docs-only --quiet
    cd docs-only
    
    echo -e "${CYAN}* Extracting docs/ as root directory${NO_COLOR}"
    echo -e "${PURPLE}  $ git filter-repo --path docs/ --path-rename docs/: --force${NO_COLOR}"
    git filter-repo --path docs/ --path-rename docs/: --force
    
    echo -e "${GREEN}* Extracted docs/ as new repository${NO_COLOR}"
    echo -e "${CYAN}* New structure:${NO_COLOR}"
    echo -e "${PURPLE}  $ ls -la${NO_COLOR}"
    ls -la | grep -v "^total" | grep -v "^\.$" | grep -v "^\.\.$$" | tail -n +2
    
    echo -e ""
    echo -e "${CYAN}* Only docs commits remain:${NO_COLOR}"
    echo -e "${PURPLE}  $ git log --oneline${NO_COLOR}"
    git log --oneline
else
    echo -e "${YELLOW}* Commands to extract docs/ subdirectory:${NO_COLOR}"
    echo -e "${PURPLE}  $ git clone original docs-only${NO_COLOR}"
    echo -e "${PURPLE}  $ cd docs-only${NO_COLOR}"
    echo -e "${PURPLE}  $ git filter-repo --path docs/ --path-rename docs/: --force${NO_COLOR}"
fi

echo -e ""
echo -e "${RED}>>> Press any key to demonstrate text replacement${NO_COLOR}"
read -t 600 -n 1

# Replace sensitive text
echo -e ""
echo -e "${YELLOW}=== Replace Sensitive Text ===${NO_COLOR}"
cd $DEMO_DIR

echo -e "${CYAN}* Creating expressions file for text replacement${NO_COLOR}"
cat > expressions.txt << 'EOF'
PASSWORD=secret123==>PASSWORD=***REMOVED***
API_KEY=abc123xyz==>API_KEY=***REMOVED***
ADMIN_PASSWORD=admin123==>ADMIN_PASSWORD=***REMOVED***
EOF

echo -e "${PURPLE}  $ cat expressions.txt${NO_COLOR}"
cat expressions.txt

if [ "$DEMO_MODE" = false ]; then
    echo -e ""
    echo -e "${CYAN}* Cloning repository${NO_COLOR}"
    git clone original sanitized --quiet
    cd sanitized
    
    echo -e "${CYAN}* Replacing sensitive text in history${NO_COLOR}"
    echo -e "${PURPLE}  $ git filter-repo --replace-text ../expressions.txt --force${NO_COLOR}"
    git filter-repo --replace-text ../expressions.txt --force
    
    echo -e "${GREEN}* Text replaced throughout history${NO_COLOR}"
    echo -e "${CYAN}* Checking credentials file:${NO_COLOR}"
    if [ -f secrets/credentials.txt ]; then
        echo -e "${PURPLE}  $ cat secrets/credentials.txt${NO_COLOR}"
        cat secrets/credentials.txt
    fi
else
    echo -e ""
    echo -e "${YELLOW}* Commands to replace sensitive text:${NO_COLOR}"
    echo -e "${PURPLE}  $ git clone original sanitized${NO_COLOR}"
    echo -e "${PURPLE}  $ cd sanitized${NO_COLOR}"
    echo -e "${PURPLE}  $ git filter-repo --replace-text expressions.txt --force${NO_COLOR}"
fi

echo -e ""
echo -e "${RED}>>> Press any key to see analysis mode${NO_COLOR}"
read -t 600 -n 1

# Analysis mode
echo -e ""
echo -e "${YELLOW}=== Repository Analysis ===${NO_COLOR}"
cd $DEMO_DIR/original

if [ "$DEMO_MODE" = false ]; then
    echo -e "${CYAN}* Analyzing repository${NO_COLOR}"
    echo -e "${PURPLE}  $ git filter-repo --analyze${NO_COLOR}"
    git filter-repo --analyze
    
    echo -e "${GREEN}* Analysis complete${NO_COLOR}"
    echo -e "${CYAN}* Analysis files created:${NO_COLOR}"
    echo -e "${PURPLE}  $ ls .git/filter-repo/analysis/${NO_COLOR}"
    ls .git/filter-repo/analysis/
    
    if [ -f .git/filter-repo/analysis/path-all-sizes.txt ]; then
        echo -e ""
        echo -e "${CYAN}* Path sizes:${NO_COLOR}"
        head -10 .git/filter-repo/analysis/path-all-sizes.txt
    fi
else
    echo -e "${YELLOW}* Command to analyze repository:${NO_COLOR}"
    echo -e "${PURPLE}  $ git filter-repo --analyze${NO_COLOR}"
    echo -e "${CYAN}* Creates analysis files in .git/filter-repo/analysis/${NO_COLOR}"
fi

echo -e ""
echo -e "${GREEN}=== Filter-Repo Demo Complete ===${NO_COLOR}"
echo -e "${YELLOW}Key Takeaways:${NO_COLOR}"
echo -e "  1. filter-repo is modern tool for history rewriting"
echo -e "  2. Can remove files/directories from all history"
echo -e "  3. Extract subdirectories as new repositories"
echo -e "  4. Replace sensitive text throughout history"
echo -e "  5. Always work on fresh clone"
echo -e "  6. Backup before filtering"
echo -e "  7. Requires team coordination for shared repos"

if [ "$DEMO_MODE" = true ]; then
    echo -e ""
    echo -e "${YELLOW}Note: Install git-filter-repo to run actual operations${NO_COLOR}"
fi
