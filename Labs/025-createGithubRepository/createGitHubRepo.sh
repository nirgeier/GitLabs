#!/bin/bash

# Your GitHub token
TOKEN="ghp_xxxxxxxxxxxxxxx"

# The name of the repository to create
REPO_NAME="CodeWizardGitLabs"

# The GitHub API URL for creating a new repository
API_URL_CREATE="https://api.github.com/user/repos"

###
### Create the repository
###
# The JSON data to send in the POST request
DATA="{\"name\":\"$REPO_NAME\"}"

# Use curl to send a POST request to the GitHub API to create a new repository
curl -H "Authorization: token $TOKEN" -d "$DATA" $API_URL_CREATE

###
### Verify that the repository exists
###
USER_NAME=nirgeier

# The API for getting the repository information
API_URL_GET="https://api.github.com/repos"

# Send a GET request to the GitHub API to "get" the repository details  
RESPONSE=$(curl -s -H "Authorization: token $TOKEN" $API_URL_GET/$USER_NAME/$REPO_NAME)

# Check if the repository exists
if [[ $RESPONSE == *"Not Found"* ]]; then
  echo "Repository does not exist"
else
  echo "Repository exists"
fi

# Clone the original repo
git clone git@github.com:nirgeier/CodeWizardGitLabs.git CodeWizardGitLabs

# Chage the repository remote to your new GitHub repo
cd FOLDER_NAME
git remote set-url origin <your new repo url>

git push origin <branch>
###
### Thats it :-)
###


