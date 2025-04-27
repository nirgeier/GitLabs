![](https://raw.githubusercontent.com/nirgeier/labs-assets/main/assets/images/code-wizard-training.png)

# Git Labs

## Exercise 01 - Under The Hood of a Simple Commit

### Overview

* In this lab, we'll create a simple commit, and we will look under the hood at the objects stored in our `.git` folder.

### Prerequisite

* Git
* `tree` command 
  * Ubuntu: `apt install tree`
  * MacOs : `brew install tree`
  
### Lab

1. Create a new folder and initialize it as a git repo
2. Create a file
3. Stage the file
4. Commit the file to your local git repo
5. View the content of `.git` folder, using `tree` or in way you would like to
6. Inspect the objects in your `.git/objects` folder using `git cat-file [-p/-t] <sha-1>`. 
7. View the content of `.git/HEAD` and `.git/refs/heads/main` what are those references?

----------------------------------------------------------------

## Solutions

<details>
<summary>Step 1 - Initialize the Repo</summary>

```bash
# Create the folder for our repo
mkdir -p /tmp/git-lab-01

# Switch to that folder
cd /tmp/git-lab-01

# Init the repository
git init
```

</details>

<details>
<summary>Step 2 - Create a file</summary>

```bash
# Create the file
echo 'aaa' > a.txt
```

</details>

<details>
<summary>Step 3 - Stage the file</summary>

```bash
# Stage the file
git add .
```

</details>

<details>
<summary>Step 4 - Commit the file</summary>

```bash
# Commit the changes
git commit -m "Initial commit"
```

</details>

<details>
<summary>Step 5 - View the content of <i><b>.git</b></i> folder
</summary>

```bash
# View .git content
tree .git/objects
```

</details>

<details>
<summary>Step 6 - Inspect the Objects under <i><b>.git/objects</b></i> folder
</summary>

* Git stores references in the `.git/refs/heads/` directory, and the `HEAD` pointer in `.git/HEAD`
* Let's look under the hood at our `HEAD` variable. 
* `HEAD` is just git's pointer to "current commit in the current branch" 
* Now, if we look at our `main` reference, we can see that it points to the latest commit.

```bash
# View the content of HEAD and the branch refs
cat .git/HEAD
cat .git/refs/heads/main
```

</details>

<details>
<summary>Step 7 - View the content of <i><b>.git/HEAD</b></i> and `.git/refs/heads/main` 
</summary>

* Git stores references in the `.git/refs/heads/` directory, and the `HEAD` pointer in `.git/HEAD`
* Let's look under the hood at our `HEAD` variable. 
* `HEAD` is just git's pointer to "current commit in the current branch" 
* Now, if we look at our `main` reference, we can see that it points to the latest commit.

```bash
# View the content of HEAD and the branch refs
cat .git/HEAD
cat .git/refs/heads/main
```

</details>

----------------------------------------------------------------

#### End of Exercise