# Bash Pragma Once

A lightweight utility for Bash scripts to prevent redundant sourcing of the same file.

## 🚀 Overview

In large Bash projects, it is common to source utility or configuration files across multiple scripts. Without a guard, sourcing the same file multiple times can lead to performance degradation, redundant variable initialization, or unexpected side effects.

`pragma_once.sh` provides a mechanism to ensure a script is sourced only once per session. Uniquely, it tracks the file's checksum, meaning if you modify the sourced file, Bash will allow it to be re-sourced to reflect the changes immediately.

## ✨ Features

- **Redundancy Prevention**: Stops a script from being executed multiple times if already loaded.
- **Content Awareness**: Uses `md5sum` to detect changes; allows re-sourcing only if the file has been edited.
- **Path Agnostic**: Uses `realpath` to ensure the same file is tracked regardless of the relative path used to source it.
- **Bash 4+ Compatible**: Includes version checks to ensure stability across different Bash environments.

## 🛠 Installation & Usage

### 1. Integration
Add the following line to the top of the script you wish to protect:

```bash
source path/to/pragma_once.sh && return 0;
```

### 2. Handling Subdirectories
If you are sourcing the utility from a subdirectory, use the following pattern to ensure the path is resolved correctly:

```bash
source $(dirname $(realpath ${BASH_SOURCE[0]}))/../pragma_once.sh && return 0;
```

## 📋 Requirements

To function correctly, this utility requires the following binaries to be present in your `$PATH`:
- `md5sum`
- `realpath`

## ⚖️ License

This project is licensed under the **Creative Commons Attribution 4.0 International (CC BY 4.0)**. 

You are free to share and adapt the material, provided you give appropriate credit.

---
*Created to bring C-style include guards to the Bash shell.*
