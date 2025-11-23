#!/bin/bash

# This script demonstrates Git bundle creation and usage by creating bundles of repositories, cloning from them, and creating incremental updates.

clear

# Set the number of the desired commits
NUMBER_OF_COMMITS=15

# Load the colors script
ROOT_FOLDER=$(git rev-parse --show-toplevel)
source ${ROOT_FOLDER}/_utils/colors.sh
source ${ROOT_FOLDER}/_utils/utils.sh

# Set the script directory
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

echo -e "${CYAN}=== Git Bundle Demo ===${NO_COLOR}"
echo -e ""

# Create temporary directory for demo
DEMO_DIR="/tmp/git-bundle-demo"
rm -rf $DEMO_DIR
mkdir -p $DEMO_DIR
cd $DEMO_DIR

# Create source repository
echo -e "${CYAN}* Creating source repository${NO_COLOR}"
mkdir source-repo
cd source-repo
git init --quiet

echo -e "${CYAN}* Adding commits${NO_COLOR}"
for i in $(seq 1 $NUMBER_OF_COMMITS); do
    echo "Commit $i" >> file.txt
    git add .
    git commit -m "Commit $i" --quiet
done

echo -e "${GREEN}* Created repository with $NUMBER_OF_COMMITS commits${NO_COLOR}"

echo -e ""
echo -e "${RED}>>> Press any key to create bundle${NO_COLOR}"
read -t 600 -n 1

# Create complete bundle
echo -e ""
echo -e "${YELLOW}=== Creating Complete Bundle ===${NO_COLOR}"
echo -e "${CYAN}* Creating bundle with all refs${NO_COLOR}"
echo -e "${PURPLE}  $ git bundle create ../repo.bundle --all${NO_COLOR}"
git bundle create ../repo.bundle --all --quiet

echo -e "${GREEN}* Bundle created: repo.bundle${NO_COLOR}"
ls -lh ../repo.bundle | awk '{print "  Size: " $5}'

echo -e ""
echo -e "${CYAN}* Verifying bundle${NO_COLOR}"
echo -e "${PURPLE}  $ git bundle verify ../repo.bundle${NO_COLOR}"
git bundle verify ../repo.bundle

echo -e ""
echo -e "${RED}>>> Press any key to clone from bundle${NO_COLOR}"
read -t 600 -n 1

# Clone from bundle
echo -e ""
echo -e "${YELLOW}=== Cloning from Bundle ===${NO_COLOR}"
cd $DEMO_DIR

echo -e "${CYAN}* Cloning repository from bundle${NO_COLOR}"
echo -e "${PURPLE}  $ git clone repo.bundle cloned-repo${NO_COLOR}"
git clone repo.bundle cloned-repo --quiet

echo -e "${GREEN}* Repository cloned!${NO_COLOR}"
cd cloned-repo
echo -e "${CYAN}* Commit count: ${YELLOW}$(git rev-list --count HEAD)${NO_COLOR}"
echo -e "${PURPLE}  $ git log --oneline${NO_COLOR}"
git log --oneline | head -5

echo -e ""
echo -e "${RED}>>> Press any key to create incremental bundle${NO_COLOR}"
read -t 600 -n 1

# Create incremental bundle
echo -e ""
echo -e "${YELLOW}=== Creating Incremental Bundle ===${NO_COLOR}"
cd $DEMO_DIR/source-repo

echo -e "${CYAN}* Adding new commits to source${NO_COLOR}"
for i in $(seq 16 20); do
    echo "Update $i" >> file.txt
    git add .
    git commit -m "Update $i" --quiet
done

echo -e "${GREEN}* Added 5 new commits${NO_COLOR}"

echo -e ""
echo -e "${CYAN}* Creating incremental bundle (last 5 commits)${NO_COLOR}"
echo -e "${PURPLE}  $ git bundle create ../update.bundle HEAD~5..HEAD${NO_COLOR}"
git bundle create ../update.bundle HEAD~5..HEAD --quiet

echo -e "${GREEN}* Update bundle created${NO_COLOR}"
ls -lh ../update.bundle | awk '{print "  Size: " $5}'

echo -e ""
echo -e "${RED}>>> Press any key to apply update${NO_COLOR}"
read -t 600 -n 1

# Apply incremental update
echo -e ""
echo -e "${YELLOW}=== Applying Incremental Update ===${NO_COLOR}"
cd $DEMO_DIR/cloned-repo

echo -e "${CYAN}* Before update: ${YELLOW}$(git rev-list --count HEAD)${CYAN} commits${NO_COLOR}"

echo -e "${CYAN}* Fetching from update bundle${NO_COLOR}"
echo -e "${PURPLE}  $ git fetch ../update.bundle main:main${NO_COLOR}"
git fetch ../update.bundle main:main

echo -e "${GREEN}* After update: ${YELLOW}$(git rev-list --count HEAD)${CYAN} commits${NO_COLOR}"

echo -e ""
echo -e "${PURPLE}  $ git log --oneline${NO_COLOR}"
git log --oneline | head -8

echo -e ""
echo -e "${YELLOW}=== Creating Branch-Specific Bundle ===${NO_COLOR}"
cd $DEMO_DIR/source-repo

echo -e "${CYAN}* Creating feature branch${NO_COLOR}"
git checkout -b feature-branch --quiet
for i in {1..3}; do
    echo "Feature $i" >> feature.txt
    git add .
    git commit -m "Feature $i" --quiet
done

echo -e "${CYAN}* Creating bundle with specific branch${NO_COLOR}"
echo -e "${PURPLE}  $ git bundle create ../feature.bundle feature-branch${NO_COLOR}"
git bundle create ../feature.bundle feature-branch --quiet

echo -e "${GREEN}* Feature bundle created${NO_COLOR}"

echo -e ""
echo -e "${CYAN}* Bundle verification${NO_COLOR}"
echo -e "${PURPLE}  $ git bundle verify ../feature.bundle${NO_COLOR}"
git bundle verify ../feature.bundle

echo -e ""
echo -e "${GREEN}=== Bundle Demo Complete ===${NO_COLOR}"
echo -e "${YELLOW}Key Takeaways:${NO_COLOR}"
echo -e "  1. Bundles package Git objects for offline transfer"
echo -e "  2. Can create complete or incremental bundles"
echo -e "  3. Clone and fetch work with bundles"
echo -e "  4. Always verify bundles before distribution"
echo -e "  5. Perfect for air-gapped environments"
