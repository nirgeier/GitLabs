#!/bin/bash

cd        /tmp
rm -rf    /tmp/local-repo
git init  /tmp/local-repo

# Switch to the new repo
cd /tmp/local-repo

# Set up local repository flags fo sign
git config user.name "user"
git config user.email "email"
git config gpg.format ssh

git config gpg.format ssh
git config user.signingkey ~/.ssh/id_rsa.pub

# Add some dummy content
echo a > a.txt 

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