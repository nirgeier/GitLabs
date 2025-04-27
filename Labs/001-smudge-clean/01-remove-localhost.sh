#!/bin/bash

# This script demonstrates how to use git smudge and clean filters to manage sensitive
# information in a .env file for example.
# It replaces the database IP address with a local IP address when checking out 
# the file and replaces it with a production IP address when adding it to the staging area.
# This is useful for keeping sensitive information out of the repository while still 
# allowing developers to work with the file locally.


clear
# Load the colors script
# Get the root folder of our demo folder
ROOT_FOLDER=$(git rev-parse --show-toplevel)
source ${ROOT_FOLDER}/_utils/colors.sh

### Define the desired filters.
### For the simplicity of the demo we use it inline
### In real life it can be any path to actual script

### The ip which we wish to use
### In real life it can be password, ip or any other value
DB_IP_LOCAL=127.0.0.1
DB_IP_PROD=10.10.10.10

echo -e ""
echo -e "Pre-defined values:"
echo -e "------------------------------------------------"
echo -e "${YELLOW}DB_IP_PROD:\t${GREEN}${DB_IP_LOCAL}${NO_COLOR}"
echo -e "${YELLOW}DB_IP_PROD:\t${GREEN}${DB_IP_PROD}${NO_COLOR}"
echo -e ""

echo -e "${CYAN}* Creating\t demo repository${NO_COLOR}"
### Create the demo repository
rm -rf      /tmp/demo_smudge
mkdir -p    /tmp/demo_smudge
cd          /tmp/demo_smudge

# Generate the .env file
echo -e "${CYAN}* Initializing\t .env file${NO_COLOR}"
cat << EOF >> .env
## Database
##  * Local:      <Any Value>
##  * Production: 10.10.10.10
database.ip=0.0.0.0

## Feature1
feature1.env=DEV
feature1.key=f1-key
feature1.name=feature1
EOF

echo -e ""
echo -e "${YELLOW}* Current .env file content${NO_COLOR}"
echo -e "------------------------------------------------"
echo -e "${GREEN}"
cat .env
echo -e "${NO_COLOR}"
echo -e "------------------------------------------------"
echo -e ""

### Init the empty repository
echo -e "${CYAN}* Initializing demo repository${NO_COLOR}"

## Init git repo
git init --quiet

# Add all files
echo -e "${CYAN}* Adding content to demo repository${NO_COLOR}"
git add .

# Commit changes
echo -e "${CYAN}* Committing content to demo repository${NO_COLOR}"
git commit -m"Initial Commit without smudge-clean" --quiet

echo -e "${RED}>>> Press any key to continue${NO_COLOR}"

# Wait for user input to continue (max timeout 600 seconds)
read -t 600 -n 1

### MacOS users should use gsed instead of sed

# Clean is applied when we add file to stage
echo -e "${CYAN}* Define clean filter${NO_COLOR}"
git config --local filter.cleanLocalhost.clean  "gsed -e 's/database.ip=.*/database.ip=${DB_IP_PROD}/g'"

# Smudge is applied when we checkout file
echo -e "${CYAN}* Define smudge filter${NO_COLOR}"
git config --local filter.cleanLocalhost.smudge "gsed -e 's/database.ip=.*/database.ip=${DB_IP_LOCAL}/g'"

###  Define the filters 
echo -e "${CYAN}* Adding filters (smudge-clean) to demo repository${NO_COLOR}"
echo '.env text eol=lf filter=cleanLocalhost' > .gitattributes

### Commit the file again after we set up the filter
echo -e "${CYAN}* Adding second commit${NO_COLOR}"
echo 'Second Commit' >> README.md

echo -e "${CYAN}* Adding the same file (.env)${NO_COLOR}"
git add .

echo -e "${CYAN}* View the diff (.env)${NO_COLOR}"
echo -e "------------------------------------------------"
git --no-pager diff --cached .env
echo -e "------------------------------------------------"

echo -e "${CYAN}* Commit changes${NO_COLOR}"

git commit -m"Second commit with smudge-clean" --quiet
echo -e "${CYAN}* Pushing second commit to git${NO_COLOR}"
git push --set-upstream origin main --quiet

echo -e ""
echo -e "${YELLOW}* Current .env file content${NO_COLOR}"
echo -e "------------------------------------------------"
echo -e "${GREEN}"
cat .env
echo -e "${NO_COLOR}"
echo -e "------------------------------------------------"
echo -e ""

echo -e "${CYAN}* Repository .env Content: ${PURPLE}\$(git show HEAD:.env)${NO_COLOR}"
echo -e "----------------------------------------------------------"
echo -e "${YELLOW}$(git show HEAD:.env)${NO_COLOR}"
echo -e "----------------------------------------------------------"
echo -e ""

echo -e "${CYAN}* Delete .env file         ${PURPLE}\$(rm -rf .env)${NO_COLOR}"
rm -rf .env

echo -e "${CYAN}* Restore .env file        ${PURPLE}\$(git restore .env)${NO_COLOR}"
git restore .env

echo -e "${CYAN}* Repository .env Content: ${PURPLE}\$(cat .env)${NO_COLOR}"
echo -e "----------------------------------------------------------"
echo -e "${GREEN}$(cat .env)${NO_COLOR}"
echo -e "----------------------------------------------------------"
echo -e ""
