#!/bin/bash

# This script demonstrates how to use git smudge and clean filters 
# to beautify a file before committing it to a git repository.
# It uses the jq tool to format JSON in a file.

clear
ROOT_FOLDER=$(git rev-parse --show-toplevel)
source ${ROOT_FOLDER}/_utils/colors.sh

echo -e "${CYAN}* Initializing demo repository${NO_COLOR}"
rm -rf    /tmp/git-smudge-clean-jq
git init  /tmp/git-smudge-clean-jq --quiet
cd        /tmp/git-smudge-clean-jq

echo -e "${CYAN}* Generating demo file${NO_COLOR}"
cat << EOF >> src.json
{"users":[{"id":1,"name":"Alice"},{"id":2,"name":"Bob"}]}
EOF

echo -e "${CYAN}* Json Content:${NO_COLOR}"
echo -e "----------------------------------------------------------"
echo -e "${YELLOW}$(cat src.json)${NO_COLOR}"
echo -e "----------------------------------------------------------"
echo -e ""

# Wait for user input to continue (max timeout 600 seconds)
echo -e "${RED}>>> Press any key to continue${NO_COLOR}"
read -t 600 -n 1

echo -e "${CYAN}* Settings smudge filter${NO_COLOR}"
echo -e "${GREEN}    git config --local filter.${YELLOW}jsonbeautify${GREEN}.clean  ${PURPLE}\"jq . \"${NO_COLOR}"
echo -e "${GREEN}    git config --local filter.${YELLOW}jsonbeautify${GREEN}.smudge ${PURPLE}\"jq . -c \"${NO_COLOR}"
git config --local filter.jsonbeautify.clean "jq . "
git config --local filter.jsonbeautify.smudge "jq . -c "
echo '*.json filter=jsonbeautify' > .gitattributes

echo -e "${CYAN}* Adding file to staging area${NO_COLOR}"
git add .

echo -e "${CYAN}* Committing changes${NO_COLOR}"
git commit -m "Initial commit" --quiet

echo -e "${CYAN}* Workdir Json Content:${NO_COLOR}"
echo -e "----------------------------------------------------------"
echo -e "${YELLOW}$(cat src.json)${NO_COLOR}"
echo -e "----------------------------------------------------------"
echo -e ""

# Wait for user input to continue (max timeout 600 seconds)
echo -e "${RED}>>> Press any key to continue${NO_COLOR}"
read -t 600 -n 1

echo -e "${CYAN}* Repository Json Content: ${PURPLE}\$(git show HEAD:src.json)${NO_COLOR}"
echo -e "----------------------------------------------------------"
echo -e "${YELLOW}$(git show HEAD:src.json)${NO_COLOR}"
echo -e "----------------------------------------------------------"
echo -e ""

