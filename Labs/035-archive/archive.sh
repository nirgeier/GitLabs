#!/bin/bash

# This script demonstrates Git archive creation by exporting repository snapshots in various formats, with different options and filters.

clear

# Set the number of the desired commits
NUMBER_OF_COMMITS=10

# Load the colors script
ROOT_FOLDER=$(git rev-parse --show-toplevel)
source ${ROOT_FOLDER}/_utils/colors.sh
source ${ROOT_FOLDER}/_utils/utils.sh

# Set the script directory
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

echo -e "${CYAN}=== Git Archive Demo ===${NO_COLOR}"
echo -e ""

# Create temporary directory for demo
DEMO_DIR="/tmp/git-archive-demo"
rm -rf $DEMO_DIR
mkdir -p $DEMO_DIR
cd $DEMO_DIR

# Create source repository
echo -e "${CYAN}* Creating demo repository${NO_COLOR}"
mkdir repo
cd repo
git init --quiet

# Create directory structure
mkdir -p src/{main,test} docs config

echo -e "${CYAN}* Adding files${NO_COLOR}"
echo "# Main Application" > src/main/app.js
echo "# Test Suite" > src/test/test.js
echo "# Documentation" > docs/README.md
echo "# Configuration" > config/settings.json
echo "node_modules/" > .gitignore

git add .
git commit -m "Initial commit" --quiet

# Add more commits
for i in $(seq 2 $NUMBER_OF_COMMITS); do
    echo "Update $i" >> src/main/app.js
    git add .
    git commit -m "Update $i" --quiet
done

echo -e "${GREEN}* Repository created with $NUMBER_OF_COMMITS commits${NO_COLOR}"

# Create version tag
git tag -a v1.0.0 -m "Release version 1.0.0"
echo -e "${GREEN}* Tagged as v1.0.0${NO_COLOR}"

echo -e ""
echo -e "${RED}>>> Press any key to create archives${NO_COLOR}"
read -t 600 -n 1

# Create basic tar archive
echo -e ""
echo -e "${YELLOW}=== Creating TAR Archive ===${NO_COLOR}"
echo -e "${CYAN}* Creating tar archive of HEAD${NO_COLOR}"
echo -e "${PURPLE}  $ git archive --format=tar HEAD > ../repo.tar${NO_COLOR}"
git archive --format=tar HEAD > ../repo.tar

echo -e "${GREEN}* Archive created${NO_COLOR}"
ls -lh ../repo.tar | awk '{print "  Size: " $5}'

echo -e ""
echo -e "${CYAN}* Contents of tar archive:${NO_COLOR}"
tar -tf ../repo.tar | head -10

echo -e ""
echo -e "${RED}>>> Press any key to create compressed archive${NO_COLOR}"
read -t 600 -n 1

# Create compressed archive
echo -e ""
echo -e "${YELLOW}=== Creating Compressed Archive ===${NO_COLOR}"
echo -e "${CYAN}* Creating gzipped tar archive${NO_COLOR}"
echo -e "${PURPLE}  $ git archive HEAD | gzip > ../repo.tar.gz${NO_COLOR}"
git archive HEAD | gzip > ../repo.tar.gz

echo -e "${GREEN}* Compressed archive created${NO_COLOR}"
echo -e "${CYAN}* Size comparison:${NO_COLOR}"
ls -lh ../repo.tar ../repo.tar.gz | awk '{print "  " $9 ": " $5}'

echo -e ""
echo -e "${RED}>>> Press any key to create ZIP archive${NO_COLOR}"
read -t 600 -n 1

# Create ZIP archive
echo -e ""
echo -e "${YELLOW}=== Creating ZIP Archive ===${NO_COLOR}"
echo -e "${CYAN}* Creating zip archive${NO_COLOR}"
echo -e "${PURPLE}  $ git archive --format=zip HEAD > ../repo.zip${NO_COLOR}"
git archive --format=zip HEAD > ../repo.zip

echo -e "${GREEN}* ZIP archive created${NO_COLOR}"
ls -lh ../repo.zip | awk '{print "  Size: " $5}'

echo -e ""
echo -e "${CYAN}* Contents of ZIP archive:${NO_COLOR}"
unzip -l ../repo.zip | head -15

echo -e ""
echo -e "${RED}>>> Press any key to create tagged release${NO_COLOR}"
read -t 600 -n 1

# Create release archive from tag
echo -e ""
echo -e "${YELLOW}=== Creating Release Archive from Tag ===${NO_COLOR}"
echo -e "${CYAN}* Creating release archive from v1.0.0${NO_COLOR}"
echo -e "${PURPLE}  $ git archive --format=tar.gz --prefix=myapp-1.0.0/ v1.0.0 > ../myapp-1.0.0.tar.gz${NO_COLOR}"
git archive --format=tar.gz --prefix=myapp-1.0.0/ v1.0.0 > ../myapp-1.0.0.tar.gz

echo -e "${GREEN}* Release archive created${NO_COLOR}"
ls -lh ../myapp-1.0.0.tar.gz | awk '{print "  Size: " $5}'

echo -e ""
echo -e "${CYAN}* Extracting to verify prefix:${NO_COLOR}"
cd ..
mkdir extract-test
cd extract-test
tar -xzf ../myapp-1.0.0.tar.gz
echo -e "${PURPLE}  $ ls -la${NO_COLOR}"
ls -la

echo -e ""
echo -e "${RED}>>> Press any key to create partial archive${NO_COLOR}"
read -t 600 -n 1

# Create partial archive
echo -e ""
echo -e "${YELLOW}=== Creating Partial Archive ===${NO_COLOR}"
cd $DEMO_DIR/repo

echo -e "${CYAN}* Archiving only src/ directory${NO_COLOR}"
echo -e "${PURPLE}  $ git archive --format=tar HEAD src/ > ../src-only.tar${NO_COLOR}"
git archive --format=tar HEAD src/ > ../src-only.tar

echo -e "${GREEN}* Partial archive created${NO_COLOR}"
echo -e "${CYAN}* Contents (src/ only):${NO_COLOR}"
tar -tf ../src-only.tar

echo -e ""
echo -e "${CYAN}* Archiving only docs/ directory${NO_COLOR}"
echo -e "${PURPLE}  $ git archive --format=zip HEAD docs/ > ../docs-only.zip${NO_COLOR}"
git archive --format=zip HEAD docs/ > ../docs-only.zip

echo -e "${GREEN}* Documentation archive created${NO_COLOR}"

echo -e ""
echo -e "${RED}>>> Press any key to demonstrate export-ignore${NO_COLOR}"
read -t 600 -n 1

# Demonstrate export-ignore
echo -e ""
echo -e "${YELLOW}=== Using export-ignore Attribute ===${NO_COLOR}"
echo -e "${CYAN}* Creating .gitattributes to exclude files${NO_COLOR}"

cat > .gitattributes << 'EOF'
# Exclude from archives
.gitignore export-ignore
.gitattributes export-ignore
src/test/ export-ignore
EOF

git add .gitattributes
git commit -m "Add export-ignore rules" --quiet

echo -e "${PURPLE}  $ cat .gitattributes${NO_COLOR}"
cat .gitattributes

echo -e ""
echo -e "${CYAN}* Creating archive with exclusions${NO_COLOR}"
echo -e "${PURPLE}  $ git archive --format=tar HEAD > ../filtered.tar${NO_COLOR}"
git archive --format=tar HEAD > ../filtered.tar

echo -e "${GREEN}* Filtered archive created${NO_COLOR}"
echo -e "${CYAN}* Contents (test/ excluded):${NO_COLOR}"
tar -tf ../filtered.tar | grep -E "(test|gitignore|gitattributes)" || echo -e "${GREEN}  ✓ Test files and Git config excluded${NO_COLOR}"

echo -e ""
echo -e "${GREEN}=== Archive Demo Complete ===${NO_COLOR}"
echo -e "${YELLOW}Key Takeaways:${NO_COLOR}"
echo -e "  1. Archives create clean snapshots without .git"
echo -e "  2. Support tar, tar.gz, zip formats"
echo -e "  3. Can archive specific commits, tags, or branches"
echo -e "  4. Use --prefix for organized extraction"
echo -e "  5. export-ignore attribute excludes files"
echo -e "  6. Perfect for releases and deployments"
