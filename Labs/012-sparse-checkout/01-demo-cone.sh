#!/bin/bash

clear
# Load the colors script
# Get the root folder of our demo folder
ROOT_FOLDER=$(git rev-parse --show-toplevel)
# Load the colors script
source ${ROOT_FOLDER}/_utils/colors.sh
source ${ROOT_FOLDER}/_utils/utils.sh

# Set the script directory
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# Create a new directory for the demo
echo -e "${CYAN}* Creating demo repository${NO_COLOR}"
rm -rf /tmp/sparse-demo /tmp/sparse-checkout-demo
git init /tmp/sparse-demo --quiet
cd /tmp/sparse-demo

echo -e "${CYAN}* Creating files${NO_COLOR}"
mkdir -p server client common 
touch server/server.txt client/client.txt common/common.txt

echo -e "${CYAN}* Adding files to the index${NO_COLOR}"
git add .
echo -e "${CYAN}* Committing files${NO_COLOR}"
git commit -m "Initial commit" --quiet
echo -e "${YELLOW}* Repository content${NO_COLOR}"
tree .

echo -e "${GREEN}Press any key to continue...${NO_COLOR}"
echo -e ""
read -t 120

echo -e "${YELLOW}* Sparse checkout${NO_COLOR}"

echo -e "${CYAN}* Clone repository with sparse checkout enabled${NO_COLOR}"
echo -e "${YELLOW}    git clone ${GREEN}--filter=blob:none ${RED}--sparse ${CYAN}. ../sparse-checkout-demo${NO_COLOR}"
git clone --filter=blob:none --sparse . ../sparse-checkout-demo --quiet

echo -e "${CYAN}* Switching to the cloned repository${NO_COLOR}"
cd ../sparse-checkout-demo
echo -e "${CYAN}* Content the cloned repository${NO_COLOR}"
tree .

echo -e "${CYAN}* Initialize sparse checkout in cone mode${NO_COLOR}"
echo -e "${YELLOW}    git sparse-checkout ${GREEN}init ${CYAN}--cone${NO_COLOR}"
git sparse-checkout init --cone

echo -e "${CYAN}* Set which directory to keep (server folder)${NO_COLOR}"
echo -e "${YELLOW}    git sparse-checkout ${GREEN}set server${NO_COLOR}"
git sparse-checkout set server

echo -e "${CYAN}* Content the cloned repository${NO_COLOR}"
tree .

