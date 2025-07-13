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
  NUMBER_OF_COMMITS=${1:-1000}
  # Check if the number of files was passed to the function, 
  # Otherwise set it to 5
  NUMBER_OF_FILES=${2:-5}
    
  echo -e "${CYAN}* Creating demo repository${NO_COLOR}"

  ### Build the repo for bisect
  rm -rf  /tmp/git-lab-demo
  mkdir   /tmp/git-lab-demo
  cd      /tmp/git-lab-demo

  echo -e "${CYAN}* Initializing demo git repository${NO_COLOR}"
  git init --quiet /tmp/git-lab-demo

  echo -e "${CYAN}* Randomize repository content with the first ${YELLOW}$NUMBER_OF_COMMITS ${CYAN}commits${NO_COLOR}"
  generate_commits $NUMBER_OF_COMMITS $NUMBER_OF_FILES
  
}

#
# Generates a specified number of commits with randomized content and messages.
#
# Arguments:
#   $1 - The number of commits to generate
#   $2 - The number of files to randomly add/delete
#
function generate_commits(){
  
  # Check if the number of commits was passed to the function, 
  # Otherwise set it to 1000
  NUMBER_OF_COMMITS=${1:-1000}
  
  # Check if the number of files was passed to the function, 
  # Otherwise set it to 5
  NUMBER_OF_FILES=${2:-5}
  
  # Set the counter(s)
  # Get the number of existing commits
  FIRST_COMMIT=$(git rev-list --all --count)
  
  # Calculate the range of commits to generate
  LAST_COMMIT=$(($FIRST_COMMIT+$NUMBER_OF_COMMITS))

  # Generate the commits
  echo -e "${CYAN}* Generating ${YELLOW}$NUMBER_OF_COMMITS ${CYAN}commits${NO_COLOR}"
  
  # Start the progress bar
  init_progress_bar $NUMBER_OF_COMMITS

  # Seed random
  RANDOM_SEED=$(date +%s)
  RANDOM=$RANDOM_SEED

  echo -e "${CYAN}* Starting commit loop...${NO_COLOR}"
  # Create commits, randomly adding or deleting files
  for (( commitIndex = $FIRST_COMMIT; commitIndex <= $LAST_COMMIT ; commitIndex++ )); do
      # Calculate progress (1-based)
      local progress_num=$((commitIndex - FIRST_COMMIT + 1))
      local progress_total=$((LAST_COMMIT - FIRST_COMMIT + 1))
      # Show the progress bar
      show_progress $progress_num $progress_total "${GREEN}Commit #$(printf "%04d" $commitIndex) / $progress_total${NO_COLOR}"

      # Call commit action logic if flag is set
      if [ -z "$COMMIT_DUMMY_FILES" ]; then
        commit_dummy_files $commitIndex $NUMBER_OF_FILES
        # If the function signaled to continue, skip the rest
        if [ $? -eq 10 ]; then
          continue
        fi
      fi
  done
}

#
# Function to handle commit actions (add/delete/random change)
# Arguments:
#   $1 - commitIndex
# Returns:
#   10 if action was handled and should continue outer loop, 0 otherwise
function commit_dummy_files() {

  # The commit index
  local commitIndex=${1:-1}

  # How any random files to generate / add / delete
  local numberOfFiles=${2:-5}
  
  # 20% just random change
  action=$((RANDOM % 10))

  # Add a random file if not already present
  idx=$((1 + RANDOM % $numberOfFiles))
  # Generate the file name
  fname="file${idx}.txt"
  
  # Check the action to perform
  # 50% chance to add a file, 
  if [ $action -lt 5 ]; then
    # If the file does not exist, create it
      if [ ! -f "$fname" ]; then
      echo -en "${CYAN}#${commitIndex} Adding $fname${NO_COLOR}"
      echo "This is $fname, commit $commitIndex" > $fname
      git add $fname
      git commit -m "#${commitIndex} + Add $fname" --quiet
      return 10
    fi
  # If the action is to delete a file  
  # 30% chance to delete a file 
  elif [ $action -lt 8 ]; then
    
    # If the file exists, delete it
    if [ -f "$fname" ]; then
      echo -en "${RED}#${commitIndex} Deleting $fname${NO_COLOR}"
      git rm $fname --quiet
      git commit -m "#${commitIndex} - Delete $fname" --quiet
      return 10
    fi
  fi
  
  # Otherwise, just make a random change
  echo  -en "${YELLOW}#${commitIndex} Random change in random.txt${NO_COLOR}"
  echo  "Random change $commitIndex: $RANDOM" > random.txt
  git   add random.txt
  git   commit -m "#${commitIndex} Random change $commitIndex" --quiet
  
  # Return 0 to indicate no special action was taken
  return 0
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
    
    # print new line once the process ended
    if [ "$percent" -eq 100 ]; then
        printf "\n\n"
    fi
}