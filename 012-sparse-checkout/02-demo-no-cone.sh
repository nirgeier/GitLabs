#!/bin/bash

# This script demonstrates Git sparse checkout in no-cone mode, using patterns to include specific files.

clear
# Load the colors script
ROOT_FOLDER=$(git rev-parse --show-toplevel)
source ${ROOT_FOLDER}/_utils/colors.sh
source ${ROOT_FOLDER}/_utils/utils.sh

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# Create a new directory for the demo
echo -e "${CYAN}* Creating demo repository (no-cone mode)${NO_COLOR}"
rm -rf sparse-demo sparse-checkout-demo
git init sparse-demo --quiet
cd sparse-demo

# Create files and folders
mkdir -p server client common
touch server/server.txt client/client.txt common/common.txt

echo -e "${CYAN}* Adding files to the index${NO_COLOR}"
git add .
echo -e "${CYAN}* Committing files${NO_COLOR}"
git commit -m "Initial commit" --quiet
echo -e "${YELLOW}* Repository content${NO_COLOR}"
tree .

echo -e ""
echo -e "${RED}--------------------------------------------${NO_COLOR}"
echo -e ""
echo -e "${YELLOW}* Sparse checkout (no-cone mode)${NO_COLOR}"

echo -e "${CYAN}* Clone repository with sparse checkout enabled${NO_COLOR}"
echo -e "${YELLOW}    git clone ${GREEN}--filter=blob:none ${RED}--sparse ${CYAN}. ../sparse-checkout-demo${NO_COLOR}"
git clone --filter=blob:none --sparse . ../sparse-checkout-demo --quiet

echo -e "${CYAN}* Switching to the cloned repository${NO_COLOR}"
cd ../sparse-checkout-demo
echo -e "${CYAN}* Content of the cloned repository${NO_COLOR}"
tree .

echo -e "${CYAN}* Initialize sparse checkout in no-cone mode${NO_COLOR}"
echo -e "${YELLOW}    git sparse-checkout ${GREEN}init ${RED}--no-cone${NO_COLOR}"
git sparse-checkout init --no-cone

echo -e "${CYAN}* Set sparse-checkout to include only client/client.txt and common/common.txt${NO_COLOR}"
echo -e "${YELLOW}    git sparse-checkout ${GREEN}set client/client.txt common/common.txt${NO_COLOR}"
git sparse-checkout set client/client.txt common/common.txt

echo -e "${CYAN}* Content of the working directory after sparse-checkout (no-cone)${NO_COLOR}"
tree .
