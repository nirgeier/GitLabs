#!/bin/bash

NO_COLOR='\033[0m'    # Text Reset
GREEN='\033[0;32m'    # Green
YELLOW='\033[0;33m'   # YELLOW
PURPLE='\033[0;35m'   # Purple
BLUE='\033[0;34m'     # Blue

echo -e ""

echo -e "${BLUE}------------------------------------------------${NO_COLOR}"
echo -e "${BLUE}--- Custom merge script                      ---${NO_COLOR}"
echo -e "${BLUE}------------------------------------------------${NO_COLOR}"
echo -e "${GREEN}Ancestor: ${YELLOW}$(cat $1)${NO_COLOR}"
echo -e "${GREEN}Current:  ${YELLOW}$(cat $2)${NO_COLOR}"
echo -e "${GREEN}Other:    ${YELLOW}$(cat $3)${NO_COLOR}"
echo -e ""

echo -e "${PURPLE}* Resolving conflict as you wish ${PURPLE}(Setting \$2)${NO_COLOR}"
echo -e ">> This is the custom resolution <<<" > $2 
echo -e "${PURPLE}* Resolution: ${YELLOW} '$(cat $2)'${NO_COLOR}"
echo -e "------------------------------------------------"

exit 0