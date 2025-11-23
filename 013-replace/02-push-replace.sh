#!/bin/bash
set -e # Exit immediately if a command exits with a non-zero status

# --- Configuration and Setup ---
DEMO_DIR="git_replace_demo_workspace"
REMOTE_DIR="/tmp/remote-repo.git"

echo "================================================="
echo "  GIT REPLACE DEMONSTRATION SCRIPT"
echo "  Goal: Replace a bad commit deep in history"
echo "================================================="

# 1. Clean up previous runs and set up a fresh environment
rm -rf "$DEMO_DIR" "$REMOTE_DIR"
mkdir "$DEMO_DIR"
cd "$DEMO_DIR"
git init -b main

echo "1. Initializing local repository and creating history..."

# 2. Commit A: Initial structure
echo "Project setup" > file1.txt
git add .
git commit -m "Commit A: Initial structure"
A_SHA=$(git rev-parse HEAD)

# 3. Commit B (The BAD commit with sensitive data)
echo "SECRET_KEY=12345" > sensitive_file.txt # <-- The mistake!
echo "Updated file 1" >> file1.txt
git add .
git commit -m "Commit B: Added feature X and accidentally a secret file"
B_SHA=$(git rev-parse HEAD) # Save the SHA of the bad commit

# 4. Commit C & D: Subsequent history (which we DON'T want to rewrite)
echo "More features added" > file2.txt
git add .
git commit -m "Commit C: Subsequent feature"
C_SHA=$(git rev-parse HEAD)

echo "Refactoring done" >> file2.txt
git commit -am "Commit D: Final commit before replacement"

echo "Current history created:"
git log --oneline
echo "-------------------------------------------------"
echo "BAD COMMIT B SHA: $B_SHA"
echo "-------------------------------------------------"


# --- Set Up Remote (Required to demonstrate push/fetch) ---
mkdir -p "$REMOTE_DIR"
git clone --bare . "$REMOTE_DIR"
git remote add origin "$REMOTE_DIR"
git push -u origin main
echo "Remote repository created and initial history pushed."

# --- Create the Replacement Object (Commit B') ---
echo -e "\n2. Creating the replacement commit (B')..."

# 1. Checkout the parent of the bad commit (Commit A)
git checkout $A_SHA -b fix-bad-commit

# 2. Recreate the files, ensuring the sensitive file is EXCLUDED
# The content of file1.txt should be updated as it was in the original bad commit
echo "Updated file 1" >> file1.txt
rm -f sensitive_file.txt # <-- Crucially, remove the sensitive file

# 3. Commit the fixed content with the desired message
git add .
git commit -m "Commit B': Fixed and sanitized version (No secret data)"
BP_SHA=$(git rev-parse HEAD) # Save the SHA of the fixed commit

echo "FIXED COMMIT B' SHA: $BP_SHA"
echo "Returning to main branch..."
git checkout main

# --- Apply the Replacement ---
echo -e "\n3. Applying 'git replace'..."
# SYNTAX: git replace <object-to-be-replaced> <replacement-object>
git replace $B_SHA $BP_SHA

echo "Replacement Applied: $B_SHA is now replaced by $BP_SHA"

# --- Verification and Use Cases ---
echo -e "\n4. Verification: The history now shows the fixed commit B'"
echo "-------------------------------------------------"
git log --oneline --graph -n 4

# Use Case 1: Check the contents of the replaced commit
echo -e "\n-- Use Case: Verify that 'sensitive_file.txt' is gone from B' --"
# 'git show' will follow the replacement pointer by default
git show $B_SHA --name-only | grep "sensitive_file.txt" || echo "Success: sensitive_file.txt is NOT in the replaced commit history."

# Use Case 2: View the ORIGINAL, bad commit contents (Bypassing the replacement)
echo -e "\n-- Use Case: View the ORIGINAL bad commit using --no-replace-objects --"
# This bypasses the replacement and shows the original object
git --no-replace-objects show $B_SHA --name-only | grep "sensitive_file.txt" && echo "Success: sensitive_file.txt IS present in the original object."

# Use Case 3: Deleting the replacement
echo -e "\n-- Use Case: Deleting the replacement ref --"
git replace -d $B_SHA
echo "Replacement reference deleted."

echo "Log now reverts to showing the ORIGINAL bad commit message:"
git log --oneline --skip 1 -n 1 | grep "Commit B: Added feature X and accidentally a secret file" && echo "Deletion Verified."

# Re-apply the replacement for the push step
git replace $B_SHA $BP_SHA

# --- Sharing the Replacement ---
echo -e "\n5. Sharing the replacement by PUSHING the replacement ref..."

# Replacements are local unless explicitly pushed
git push origin "refs/replace/*"
echo "Successfully pushed the replacement reference to origin."

# Simulate a collaborator/second user cloning and fetching the replacement
echo -e "\n6. Simulating a Collaborator Fetching the Replacement..."
cd ..
mkdir second_user_repo
cd second_user_repo

git clone "$REMOTE_DIR" .
echo "Cloned repository (Initial clone does NOT include the replacement)."
echo "Log in this clone (should show the BAD commit B):"
git log --oneline --skip 1 -n 1

echo "Fetching replacement refs explicitly..."
git fetch origin 'refs/replace/*:refs/replace/*'

echo "Log after fetching replacement refs (should show the FIXED commit B'):"
git log --oneline --skip 1 -n 1

# --- Clean up ---
echo -e "\n7. Cleaning up the demonstration environment..."
cd ../
rm -rf "$DEMO_DIR" "$REMOTE_DIR" second_user_repo
echo "Cleanup complete."