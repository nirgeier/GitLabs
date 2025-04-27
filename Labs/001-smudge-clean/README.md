# Advanced Git - Smudge Clean

<div align="center">

<img src="/_utils/images/advanced_git.jpg" alt="Advanced Git" width="300px" height="auto" style="border-radius: 50%"/>

</div>


---
<!-- omit in toc -->
# Table of Contents
- [Advanced Git - Smudge Clean](#advanced-git---smudge-clean)
  - [Preface](#preface)
  - [Usage](#usage)
    - [`.gitconfig`](#gitconfig)
    - [`.gitattributes`](#gitattributes)
  - [Demos](#demos)

---

## Preface

1. Git `smudge clean` filters are used to modify **files** as they are **checked** out or **checked** into a Git repository.
2. This allows for **automatic transformations** of files during the checkout process, ensuring that the working directory contains the **desired** content of the files.
3. The `smudge` filter is applied when files are **checked out**, while the `clean` filter is applied when files are checked in.
  
- This can be useful for tasks such as:
  - Converting line endings
  - Compressing files
  - Encrypting files
  - Any other transformation that needs to be applied to files during the checkout or check-in process.
  - For example, you can use a `smudge` filter to automatically convert line endings from LF to CRLF when checking out files on Windows, and a `clean` filter to convert them back to LF when checking in files. 
- The `smudge` and `clean` filters are defined in the `.gitattributes` file, which is used to specify attributes for files in a Git repository.
- The filters can be defined using the `filter` attribute, and the commands to be executed for the `smudge` and `clean` filters can be specified using the `smudge` and `clean` attributes, respectively.
- The filters can be defined for specific file types or for all files in the repository.
- The `smudge` and `clean` filters are executed as part of the Git command that checks out or checks in files, and they can be used to modify the content of the files as they are processed by Git.
- The `smudge` and `clean` filters are executed in the order they are defined in the `.gitattributes` file, and they can be used in combination with other Git features such as hooks and submodules.


## Usage
- The `smudge` and `clean` filters are defined in the `.gitattributes` file, which is used to specify attributes for files in a Git repository.
  
  ### `.gitconfig`

  - `.git/config` or `~/.gitconfig` file:
    
    ```shell
    ### Set the filter commands
    git config --local filter.<your filter name>.clean <Command/Script>
    git config --local filter.<your filter name>.smudge <Command/Script>

    [filter "cleanLocalhost"]
      clean   = /path/to/clean
      smudge  = /path/to/smudge

    ```

  ### `.gitattributes`
  
  - `.gitattributes` file:
      ```shell
      ### Add the following lines to the .gitattributes file to define the filters for the files
      *.env filter=cleanLocalhost
      *.txt filter=cleanLocalhost
      ```
---

## Demos


