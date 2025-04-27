#!/bin/bash

clear
# Load the colors script
ROOT_FOLDER=$(git rev-parse --show-toplevel)
source ${ROOT_FOLDER}/_utils/colors.sh
source ${ROOT_FOLDER}/_utils/utils.sh

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# Create a new directory for the demo
echo -e "${CYAN}* Creating demo repository (pattern mode)${NO_COLOR}"
rm -rf sparse-demo-pattern sparse-checkout-pattern-demo
git init sparse-demo-pattern --quiet
cd sparse-demo-pattern

# Create files and folders
mkdir -p server client common
for i in 1 2 3 4 5; do
  touch server/server${i}.txt client/client${i}.txt common/common${i}.txt
  touch server/server${i}.log client/client${i}.log common/common${i}.log
  touch server/server${i}.md client/client${i}.md common/common${i}.md
done

echo -e "${CYAN}* Adding files to the index${NO_COLOR}"
git add .
echo -e "${CYAN}* Committing files${NO_COLOR}"
git commit -m "Initial commit with patterns" --quiet
echo -e "${YELLOW}* Repository content${NO_COLOR}"
tree .

echo -e ""
echo -e "${RED}--------------------------------------------${NO_COLOR}"
echo -e ""
echo -e "${YELLOW}* Sparse checkout (no-cone mode, patterns)${NO_COLOR}"

echo -e "${CYAN}* Clone repository with sparse checkout enabled${NO_COLOR}"
echo -e "${YELLOW}    git clone ${GREEN}--filter=blob:none ${RED}--sparse ${CYAN}. ../sparse-checkout-pattern-demo${NO_COLOR}"
git clone --filter=blob:none --sparse . ../sparse-checkout-pattern-demo --quiet

echo -e "${CYAN}* Switching to the cloned repository${NO_COLOR}"
cd ../sparse-checkout-pattern-demo
echo -e "${CYAN}* Content of the cloned repository${NO_COLOR}"
tree .

echo -e "${CYAN}* Initialize sparse checkout in no-cone mode${NO_COLOR}"
echo -e "${YELLOW}    git sparse-checkout ${GREEN}init ${RED}--no-cone${NO_COLOR}"
git sparse-checkout init --no-cone

echo -e "${CYAN}* Set sparse-checkout to include all *.txt files in client and common directories${NO_COLOR}"
echo -e "${YELLOW}    git sparse-checkout ${GREEN}set 'client/*.txt' 'common/*.txt'${NO_COLOR}"
git sparse-checkout set 'client/*.txt' 'common/*.txt'

echo -e "${CYAN}* Content of the working directory after sparse-checkout (pattern)${NO_COLOR}"
tree .
