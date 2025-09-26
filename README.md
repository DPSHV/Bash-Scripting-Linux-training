# 🐧 Linux + Bash Bootcamp Scripts

A collection of scripts written during a 24-day bootcamp. Each day combines practical Linux sysadmin topics with Bash scripting exercises.  
All scripts follow a **production-grade style**:
- `set -euo pipefail`
- unified logging (`[INFO]`, `[WARN]`, `[ERROR]`)
- proper quoting of variables
- clear exit codes

## 📂 Repository structure

day04-05/   – processes, loops, file operations  
day06/      – streams, functions  
day07/      – users and groups  
day08/      – networking basics and health checks  
day09/      – systemd and services  
...

Each folder contains 2–3 scripts from that day plus a short README with details.

## ⚡ Quick start

All scripts are written for `/bin/bash`. To run:

    chmod +x script.sh
    ./script.sh [args]

Example:

    ./service_checker.sh sshd nginx

Output:

    SERVICE                  ACTIVE     ENABLED
    sshd                     active     enabled
    nginx                    inactive   disabled

## 🛠️ Requirements

- Bash 5.x (most Linux distros)  
- System tools: `systemctl`, `ip`, `ss`, `awk`, `grep`, `getent`, `nc`  
- Root privileges for scripts that manage users or services  

## 📖 Script header convention

Every file starts with a uniform header block:

    # ================================================================
    # Script: <name>.sh
    # Description:
    #   Short description (1–3 lines).
    #   Flags: (optional)
    #     --flag : short explanation
    #
    # Usage:
    #   ./<name>.sh <args>
    #
    # Notes:
    #   - bullet list: requirements, tools, limitations
    #
    # Author: shovker
    # ================================================================

This makes it quick to understand what a script does and how to run it.

## 🎯 Purpose

This repository is not a set of copy-paste one-liners. It’s a **hands-on workshop**:
- demonstrates how to write solid admin-grade Bash scripts  
- shows how to use key Linux tools  
- enforces best practices (parsing, quoting, error handling)  

The repo serves as both **notes and a toolbox** for further work in sysadmin and DevOps.

---

Author: **shovker**
