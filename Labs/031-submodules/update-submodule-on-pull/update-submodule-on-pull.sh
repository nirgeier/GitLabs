#!/bin/bash

# This script demonstrates updating Git submodules automatically on pull operations.

###
### This demo will demonstrate how to update submodules on 
### a git repository when the pull command is executed
###

### Hack - set the file allowed flag in the corrent repository
### Will be reset back at the end of this script
### Get the current value of the configuration variable
FILE_ALLOW=$(git config --global --get protocol.file.allow)
git config --global protocol.file.allow always

## Initialize the "remote repository"
echo "* Initialize the 'remote repository' [/tmp/remoteRepository] "
rm -rf /tmp/remoteRepository
git init --bare /tmp/remoteRepository > /dev/null 2>&1

echo "* Initialize the 'local repository' [/tmp/localRepository] "
rm -rf /tmp/localRepository
git clone /tmp/remoteRepository /tmp/localRepository > /dev/null 2>&1
cd /tmp/localRepository
git checkout -b main > /dev/null 2>&1
git commit --allow-empty -m"Initial commit" > /dev/null 2>&1
git push origin main

## List fo repositories for this demo
declare -a submodule=(
    "/tmp/submodule-A" 
    "/tmp/submodule-B"
)

## Loop through each repository
for submodule in "${submodule[@]}"
do
  echo "----------------------------------------------------------------"
  echo "* Remove old repository ${submodule}"
  rm -rf ${submodule}
  
  echo "* Create new repository ${submodule}"
  git init ${submodule} > /dev/null 2>&1
  
  echo "* Create content in ${submodule}"
  cd    ${submodule}
  echo  ${submodule} > "${submodule}.txt" &&    \
     git add . &&                                  \
     git commit -m "Initial commit - $(basename $(pwd))" > /dev/null 2>&1
done

###
### Add submodules to the main repository
### 
echo "* Switching to the main repository"
cd /tmp/localRepository

echo "* Adding submodules"
git submodule add /tmp/submodule-A submodule-A
git submodule add /tmp/submodule-B submodule-B

echo "* Updating submodules"
git submodule init
git submodule update

echo "* Current content"
tree .

git pull origin main

echo "* Current content"

###
### Reset file allow configuration to its original state
###
echo "* Switching 'protocol.file.allow' to its original value"
git config --global protocol.file.allow "$FILE_ALLOW"



exit 0
