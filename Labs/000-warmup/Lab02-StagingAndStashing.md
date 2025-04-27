![](https://raw.githubusercontent.com/nirgeier/labs-assets/main/assets/images/code-wizard-training.png)

# Git Labs

## Exercise 02 - 3 States 

### Overview

* In this lab, we'll take a quick look at 3 states understanding its structure and how to properly use it

### Prerequisite

* Git
  
### Lab

1. Create a new repository and Initialize it with few files and commits ([Lab01](./Lab01-SimpleCommit.md))
2. Create and and new files to the staging area
3. View the staging area 
4. View the staging area **content**. [Use `git ls-files -s`] and explain what you see.
5. Make a change and now stage it interactively (`git add -p`), run `git status` and explain what you see
6. Unstage your change. Use any command you know to "undo" your changes and revert to the committed file

----------------------------------------------------------------

## Solutions

<details>
<summary>Step 1 - Initialize the Repo</summary>

```bash
# Create the folder for our repo
mkdir -p /tmp/git-lab-02

# Switch to that folder
cd /tmp/git-lab-02

# Init the repository
git init

# Add files and commit
for i in {1..5}; 
do 
  echo "Random text... $RANDOM" > file$i.txt; 
  git add . && git commit -m"$RANDOM commit"; 
done

git log
```

</details>

<details>
<summary>Step 2 - Create a file, stage it, and commit </summary>

* Under the hood, the `staging area` is a `file` that contains a `list of files`, as well as the SHA1 of the version that's in the repository.
* Use `git ls-files -s` to view the `hello.txt` file that we checked in previously. 
* The SHA1 hash displayed points to the blob object - which contains the contents of the file.

```sh
# Creating file(s) and adding it to the stage areas
echo 'aaa' > a.txt 
echo 'ccc' > c.txt 

# Add file to the staging area
git add a.txt
```

</details>

<details>

<summary>Step 3 - git status </summary>

```sh
# View the staging area 
git status
```

</details>

<details>
<summary>Step 4 - View the staging area <b>content</b></summary>

```sh
# View the staging area content
git ls-files -s

### What do you see? Explain
```

</details>

<details>
<summary>Step 5 - Interactively staging</summary>

```sh
# "update" the content of your files
# by adding first line and last line
# Create a temporary file
temp_file=$(mktemp)
echo "This is new first line" > "$temp_file"
cat a.txt >> "$temp_file"
echo "This is new last line" > "$temp_file"
mv $temp_file a.txt

# View the updated content
cat a.txt  

# Use git add -p to add the first line to staging area
git add -p a.txt
# s - split
# y - yes
# n - no

## Stage this hunk [y,n,q,a,d,/,e,?]?
## If you type `?` and press `enter` after `Stage this hunk`, git will explain the shortcut keys:

## Stage this hunk [y,n,q,a,d,/,e,?]?
## y - stage this hunk
## n - do not stage this hunk
## q - quit; do not stage this hunk or any of the remaining ones
## a - stage this hunk and all later hunks in the file
## d - do not stage this hunk or any of the later hunks in the file
## g - select a hunk to go to
## / - search for a hunk matching the given regex
## j - leave this hunk undecided, see next undecided hunk
## J - leave this hunk undecided, see next hunk
## k - leave this hunk undecided, see previous undecided hunk
## K - leave this hunk undecided, see previous hunk
## s - split the current hunk into smaller hunks
## e - manually edit the current hunk
## ? - print help

# Verify the changes in the staging area
git status
git diff --staged a.txt

```

</details>


<details>
<summary>Step 6 - Discard changes</summary>

```sh
# Restore the file form the repository 
git restore a.txt
```
</details>

#### End of Exercise Two
