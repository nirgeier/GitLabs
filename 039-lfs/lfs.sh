#!/bin/bash

# This script demonstrates Git LFS (Large File Storage) by showing how to track large files, manage LFS objects, and work with LFS-enabled repositories.

clear

# Load the colors script
ROOT_FOLDER=$(git rev-parse --show-toplevel)
source ${ROOT_FOLDER}/_utils/colors.sh
source ${ROOT_FOLDER}/_utils/utils.sh

echo -e "${CYAN}=== Git LFS Demo ===${NO_COLOR}"
echo -e ""

# Check if git-lfs is installed
if ! command -v git-lfs &> /dev/null; then
    echo -e "${RED}* git-lfs not found${NO_COLOR}"
    echo -e "${YELLOW}* Installation instructions:${NO_COLOR}"
    echo -e "  macOS:         ${PURPLE}brew install git-lfs${NO_COLOR}"
    echo -e "  Ubuntu/Debian: ${PURPLE}sudo apt install git-lfs${NO_COLOR}"
    echo -e "  Then run:      ${PURPLE}git lfs install${NO_COLOR}"
    echo -e ""
    echo -e "${CYAN}* This demo will show the commands but requires git-lfs to execute${NO_COLOR}"
    DEMO_MODE=true
else
    echo -e "${GREEN}* git-lfs is installed${NO_COLOR}"
    DEMO_MODE=false
fi

echo -e ""
echo -e "${RED}>>> Press any key to continue${NO_COLOR}"
read -t 600 -n 1

# Create temporary directory for demo
DEMO_DIR="/tmp/git-lfs-demo"
rm -rf $DEMO_DIR
mkdir -p $DEMO_DIR
cd $DEMO_DIR

# Create repository
echo -e ""
echo -e "${CYAN}* Creating demo repository${NO_COLOR}"
mkdir lfs-repo
cd lfs-repo
git init --quiet

if [ "$DEMO_MODE" = false ]; then
    echo -e "${CYAN}* Initializing Git LFS${NO_COLOR}"
    echo -e "${PURPLE}  $ git lfs install${NO_COLOR}"
    git lfs install
    
    echo -e "${GREEN}* Git LFS initialized${NO_COLOR}"
else
    echo -e "${YELLOW}* Command to initialize Git LFS:${NO_COLOR}"
    echo -e "${PURPLE}  $ git lfs install${NO_COLOR}"
fi

echo -e ""
echo -e "${RED}>>> Press any key to track large files${NO_COLOR}"
read -t 600 -n 1

# Track file patterns
echo -e ""
echo -e "${YELLOW}=== Tracking Large Files ===${NO_COLOR}"

if [ "$DEMO_MODE" = false ]; then
    echo -e "${CYAN}* Configuring LFS to track specific file types${NO_COLOR}"
    
    echo -e "${PURPLE}  $ git lfs track '*.zip'${NO_COLOR}"
    git lfs track "*.zip"
    
    echo -e "${PURPLE}  $ git lfs track '*.mp4'${NO_COLOR}"
    git lfs track "*.mp4"
    
    echo -e "${PURPLE}  $ git lfs track '*.psd'${NO_COLOR}"
    git lfs track "*.psd"
    
    echo -e "${GREEN}* LFS tracking configured${NO_COLOR}"
    
    echo -e ""
    echo -e "${CYAN}* .gitattributes file created:${NO_COLOR}"
    echo -e "${PURPLE}  $ cat .gitattributes${NO_COLOR}"
    cat .gitattributes
    
    echo -e ""
    echo -e "${CYAN}* Committing .gitattributes${NO_COLOR}"
    git add .gitattributes
    git commit -m "Configure LFS tracking" --quiet
else
    echo -e "${YELLOW}* Commands to track large file types:${NO_COLOR}"
    echo -e "${PURPLE}  $ git lfs track '*.zip'${NO_COLOR}"
    echo -e "${PURPLE}  $ git lfs track '*.mp4'${NO_COLOR}"
    echo -e "${PURPLE}  $ git lfs track '*.psd'${NO_COLOR}"
    echo -e ""
    echo -e "${CYAN}* This creates/updates .gitattributes${NO_COLOR}"
fi

echo -e ""
echo -e "${RED}>>> Press any key to add large files${NO_COLOR}"
read -t 600 -n 1

# Add large files
echo -e ""
echo -e "${YELLOW}=== Adding Large Files ===${NO_COLOR}"

echo -e "${CYAN}* Creating simulated large files${NO_COLOR}"

# Create dummy large files
dd if=/dev/zero of=large-video.mp4 bs=1M count=10 2>/dev/null
dd if=/dev/zero of=archive.zip bs=1M count=5 2>/dev/null
dd if=/dev/zero of=design.psd bs=1M count=8 2>/dev/null

echo -e "${GREEN}* Created 3 large files${NO_COLOR}"
ls -lh *.mp4 *.zip *.psd | awk '{print "  " $9 ": " $5}'

echo -e ""
echo -e "${CYAN}* Adding files to repository${NO_COLOR}"
git add .
git commit -m "Add large files" --quiet

if [ "$DEMO_MODE" = false ]; then
    echo -e ""
    echo -e "${CYAN}* Listing LFS-tracked files:${NO_COLOR}"
    echo -e "${PURPLE}  $ git lfs ls-files${NO_COLOR}"
    git lfs ls-files
    
    echo -e ""
    echo -e "${CYAN}* Showing LFS file sizes:${NO_COLOR}"
    echo -e "${PURPLE}  $ git lfs ls-files --size${NO_COLOR}"
    git lfs ls-files --size
fi

echo -e ""
echo -e "${RED}>>> Press any key to see pointer files${NO_COLOR}"
read -t 600 -n 1

# Show pointer files
echo -e ""
echo -e "${YELLOW}=== LFS Pointer Files ===${NO_COLOR}"

if [ "$DEMO_MODE" = false ]; then
    echo -e "${CYAN}* Showing pointer file content (not actual large file):${NO_COLOR}"
    echo -e "${PURPLE}  $ git cat-file -p HEAD:large-video.mp4${NO_COLOR}"
    git cat-file -p HEAD:large-video.mp4 | head -5
    
    echo -e ""
    echo -e "${YELLOW}* Notice: Git stores small pointer, not 10MB file${NO_COLOR}"
else
    echo -e "${YELLOW}* LFS stores pointers in Git, actual files separate${NO_COLOR}"
    echo -e "${CYAN}* Pointer example:${NO_COLOR}"
    cat << 'EOF'
version https://git-lfs.github.com/spec/v1
oid sha256:abc123...
size 10485760
EOF
fi

echo -e ""
echo -e "${RED}>>> Press any key to check LFS environment${NO_COLOR}"
read -t 600 -n 1

# Check LFS environment
echo -e ""
echo -e "${YELLOW}=== LFS Environment ===${NO_COLOR}"

if [ "$DEMO_MODE" = false ]; then
    echo -e "${CYAN}* Showing LFS configuration:${NO_COLOR}"
    echo -e "${PURPLE}  $ git lfs env${NO_COLOR}"
    git lfs env | head -15
    
    echo -e ""
    echo -e "${CYAN}* Listing tracked patterns:${NO_COLOR}"
    echo -e "${PURPLE}  $ git lfs track${NO_COLOR}"
    git lfs track
else
    echo -e "${YELLOW}* Command to show LFS environment:${NO_COLOR}"
    echo -e "${PURPLE}  $ git lfs env${NO_COLOR}"
    echo -e ""
    echo -e "${YELLOW}* Command to list tracked patterns:${NO_COLOR}"
    echo -e "${PURPLE}  $ git lfs track${NO_COLOR}"
fi

echo -e ""
echo -e "${RED}>>> Press any key to simulate clone${NO_COLOR}"
read -t 600 -n 1

# Clone repository
echo -e ""
echo -e "${YELLOW}=== Cloning LFS Repository ===${NO_COLOR}"

cd $DEMO_DIR

if [ "$DEMO_MODE" = false ]; then
    echo -e "${CYAN}* Cloning repository${NO_COLOR}"
    echo -e "${PURPLE}  $ git clone lfs-repo lfs-clone${NO_COLOR}"
    git clone lfs-repo lfs-clone --quiet
    
    cd lfs-clone
    
    echo -e "${GREEN}* Clone complete${NO_COLOR}"
    
    echo -e ""
    echo -e "${CYAN}* LFS files automatically downloaded:${NO_COLOR}"
    ls -lh *.mp4 *.zip *.psd 2>/dev/null | awk '{print "  " $9 ": " $5}'
    
    echo -e ""
    echo -e "${CYAN}* LFS files in clone:${NO_COLOR}"
    echo -e "${PURPLE}  $ git lfs ls-files${NO_COLOR}"
    git lfs ls-files
else
    echo -e "${YELLOW}* Cloning automatically downloads LFS files:${NO_COLOR}"
    echo -e "${PURPLE}  $ git clone <repo-url>${NO_COLOR}"
    echo -e ""
    echo -e "${CYAN}* For manual LFS fetch:${NO_COLOR}"
    echo -e "${PURPLE}  $ git lfs fetch${NO_COLOR}"
    echo -e "${PURPLE}  $ git lfs pull${NO_COLOR}"
fi

echo -e ""
echo -e "${YELLOW}=== LFS Management Commands ===${NO_COLOR}"
echo -e ""
echo -e "${CYAN}List LFS objects:${NO_COLOR}"
echo -e "${PURPLE}  $ git lfs ls-files${NO_COLOR}"
echo -e ""
echo -e "${CYAN}Fetch LFS objects:${NO_COLOR}"
echo -e "${PURPLE}  $ git lfs fetch${NO_COLOR}"
echo -e "${PURPLE}  $ git lfs fetch --all${NO_COLOR}"
echo -e ""
echo -e "${CYAN}Pull LFS objects:${NO_COLOR}"
echo -e "${PURPLE}  $ git lfs pull${NO_COLOR}"
echo -e ""
echo -e "${CYAN}Prune old LFS objects:${NO_COLOR}"
echo -e "${PURPLE}  $ git lfs prune${NO_COLOR}"
echo -e "${PURPLE}  $ git lfs prune --dry-run${NO_COLOR}"
echo -e ""
echo -e "${CYAN}Migrate existing files:${NO_COLOR}"
echo -e "${PURPLE}  $ git lfs migrate import --include='*.zip'${NO_COLOR}"

echo -e ""
echo -e "${GREEN}=== Git LFS Demo Complete ===${NO_COLOR}"
echo -e "${YELLOW}Key Takeaways:${NO_COLOR}"
echo -e "  1. LFS stores large files separately from Git"
echo -e "  2. Only small pointer files stored in repository"
echo -e "  3. Track files by pattern in .gitattributes"
echo -e "  4. Large files downloaded on clone/checkout"
echo -e "  5. Reduces repository size and clone time"
echo -e "  6. Perfect for media, archives, datasets"
echo -e "  7. Requires LFS support from Git hosting"

if [ "$DEMO_MODE" = true ]; then
    echo -e ""
    echo -e "${YELLOW}Note: Install git-lfs to run actual operations${NO_COLOR}"
fi
