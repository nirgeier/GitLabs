#!/bin/bash

# Clone the original repo
cd        /tmp
rm -rf    /tmp/local-repo
git init  /tmp/local-repo

# Switch to the new repo
cd /tmp/local-repo

git config commit.gpgsign true
git config user.signingkey CB7FF013714B2BD3

# Set permissions to file
for i in {1..3};
do 
  echo $i > $i.txt 
done  

# Commit the changes
git add .
git commit -s -m "Initial commit"

echo -e ""
echo -e "----------------------------------------------------------------"
echo -e ""
echo -e "$ git verify-commit HEAD"
git verify-commit HEAD

echo -e ""
echo -e "----------------------------------------------------------------"
echo -e ""
echo -e "$ git show HEAD"
git show HEAD