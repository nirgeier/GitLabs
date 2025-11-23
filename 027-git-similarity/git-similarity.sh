#!/bin/bash

# This script demonstrates analyzing code similarity between commits and files in a Git repository.

# Function to set up a sample repository
setup_repo() {
    mkdir git-similarity-demo
    cd git-similarity-demo
    git init

    # Create initial file
    cat << EOF > sample.py
def greet(name):
    print(f"Hello, {name}!")

def calculate_sum(a, b):
    return a + b

if __name__ == "__main__":
    greet("World")
    print(calculate_sum(5, 3))
EOF

    git add sample.py
    git commit -m "Initial commit"
}

# Function to make changes and commit
make_changes() {
    # Modify existing file
    cat << EOF > sample.py
def greet(name):
    print(f"Hello, {name}!")

def calculate_sum(a, b):
    return a + b

def calculate_product(a, b):
    return a * b

if __name__ == "__main__":
    greet("Git")
    print(calculate_sum(10, 5))
    print(calculate_product(4, 3))
EOF

    git add sample.py
    git commit -m "Added product function and modified main"

    # Create a similar file
    cat << EOF > sample_copy.py
def welcome(name):
    print(f"Welcome, {name}!")

def add_numbers(a, b):
    return a + b

def multiply_numbers(a, b):
    return a * b

if __name__ == "__main__":
    welcome("Git")
    print(add_numbers(10, 5))
    print(multiply_numbers(4, 3))
EOF

    git add sample_copy.py
    git commit -m "Added similar file sample_copy.py"
}

# Function to show similarity between two commits
show_commit_similarity() {
    echo    "Similarity between $1 and $2:"
    git     diff --stat $1 $2
    echo    ""
    echo    "Detailed changes:"
    git     diff-tree --color-words $1 $2
}

# Function to show similarity between two files
show_file_similarity() {
    echo "Similarity between $1 and $2:"
    git diff --no-index --stat $1 $2
    echo ""
    echo "Similarity percentage:"
    similarity=$(git diff --no-index --numstat $1 $2 | awk '{print $1, $2}' | 
                 awk '{total += $1 + $2} END {print int((1 - total / (100 + total)) * 100)}')
    echo "${similarity}% similar"
    echo ""
    echo "Detailed changes:"
    git diff --no-index --color-words $1 $2
}

# Function to find similar code within the repository
find_similar_code() {
    echo "Finding similar code patterns:"
    git grep -n "def"
}

# Main script execution
setup_repo

# Make some changes
make_changes

# Show similarity between initial commit and latest commit
initial_commit=$(git rev-list --max-parents=0 HEAD)
latest_commit=$(git rev-parse HEAD)
show_commit_similarity $initial_commit $latest_commit

# Show similarity between two files
echo ""
echo "Comparing sample.py and sample_copy.py:"
show_file_similarity sample.py sample_copy.py

# Find similar code patterns
echo ""
find_similar_code

echo "Git code similarity demonstration completed."