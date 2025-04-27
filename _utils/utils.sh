
#!/bin/bash

################################################################
## Utils functions for the demos
################################################################
# Get the root folder of our demo folder
ROOT_FOLDER=$(git rev-parse --show-toplevel)
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
source ${ROOT_FOLDER}/_utils/progressBar.sh

#
# Function which create a git repo with dummy content
#
function generate_repository(){

  # Check if the number of commits was passed to the function, 
  # Otherwise set it to 100
  NUMBER_OF_COMMITS=${1:-10}
  
  echo -e "${CYAN}* Creating demo repository${NO_COLOR}"

  ### Build the repo for bisect
  rm -rf  /tmp/git-lab-demo
  mkdir   /tmp/git-lab-demo
  cd      /tmp/git-lab-demo

  echo -e "${CYAN}* Initializing demo git repository${NO_COLOR}"
  git init --quiet

  echo -e "${CYAN}* Randomize repository content with the first ${YELLOW}$NUMBER_OF_COMMITS ${CYAN}commits${NO_COLOR}"
  generate_commits $NUMBER_OF_COMMITS

}

#
# Function to generate random commits
#
# Arguments:
#   $1 - The number of commits to generate
#
# Returns:
#   None
#
# Generates a specified number of commits with randomized content and messages.
function generate_commits(){

  # Check if the number of commits was passed to the function, 
  # Otherwise set it to 1000
  NUMBER_OF_COMMITS=${1:-1000}
  
  # Set the counter(s)
  # Get the number of existing commits
  FIRST_COMMIT=$(git rev-list --all --count)
  
  # Calculate the range of commits to generate
  LAST_COMMIT=$(($FIRST_COMMIT+$NUMBER_OF_COMMITS))

  # Generate the commits
  echo -e "${CYAN}* Generating ${YELLOW}$NUMBER_OF_COMMITS ${CYAN}commits${NO_COLOR}"
  
  init_progress_bar $NUMBER_OF_COMMITS

  # Loop through the commits and add random files with content and messages
  for (( filenumber = $FIRST_COMMIT; filenumber <= $LAST_COMMIT ; filenumber++ ));
  do  
      # Print the progress bar
      #echo -ne $( print_progress $(($filenumber*100/$LAST_COMMIT)) "${GREEN}Commit #$(printf "%04d" $filenumber) / ${LAST_COMMIT} ${NO_COLOR}")
      show_progress $(( $filenumber-$FIRST_COMMIT )) $(( $LAST_COMMIT-$FIRST_COMMIT)) "${GREEN}Commit #$(printf "%04d" $filenumber) / ${LAST_COMMIT}${NO_COLOR}"
      
      # Add content and commit
      echo -en "Some new random text: $RANDOM" > random1.txt
      git add .
      git commit -m"A random change" --quiet
  done

  echo -e ""

}
##
## This script will print out a progress bar 
## 
function print_progress() {
    # Get the progress information
    local percent=$1
    # Get the prefix message
    local progress_message=$2
    # Number of bytes to print
    local width=50
    # Calculate the width of the progress bar
    local completed=$((percent * width / 100))
    # Calculate the remaining width
    local remaining=$((width-completed))
    
    show_progress 
    # print the progress information
    printf "\r$progress_message"
    #printf "%3d%%" "$percent" 
    printf " ["
    printf "%${completed}s ${BYELLOW}$percent%%${NO_COLOR}" | tr ' ' '▓'
    printf "%${remaining}s" | tr ' ' '░'
    printf "]"
    
    # prrint new line once the process ended
    if [ "$percent" -eq 100 ]; then
        printf "\n\n"
    fi
}