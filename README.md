# 🧰 Bash & Linux Admin Scripting Portfolio

This repository is a curated collection of Bash scripts developed during my deep-dive into Linux system administration and shell scripting.

Each script is purpose-built to explore a specific concept or solve a real-world task — with a strong focus on correctness, clarity, and production-readiness.

> 💡 Think of this as a hands-on portfolio: designed for both learning and demonstrating practical Bash/Linux skills.

---

## 📌 What’s Inside

- **Self-contained scripts**, each with clear purpose and usage
- **Topics covered**:
  - Process inspection and control
  - Filesystem operations
  - Text processing and filtering
  - Logging and validation
  - Safe script structure and flag parsing (`--dry-run`, `--help`, etc.)
- **Tools used**: `grep`, `find`, `cut`, `sort`, `uniq`, `wc`, `ps`, `stat`, `tail`, etc.
- **Scripting techniques**:
  - Functions, loops, case-switch parsing
  - Parameter expansion
  - Input validation
  - Safe defaults (`set -euo pipefail`)

---

## 📂 Example Scripts

| Script                 | Description                                          |
|------------------------|------------------------------------------------------|
| `user_process_report.sh` | Lists and counts processes for current user        |
| `files_linecount.sh`     | Totals line counts across given files              |
| `txt_backup.sh`          | Backs up `.txt` files with date suffix (supports `--dry-run`) |
| `find_uniq_errors.sh`    | Extracts and deduplicates error lines from logs    |

All scripts follow consistent structure and are written to be **understandable, maintainable, and reusable**.

---

## 🎯 Purpose

This repository serves both as:

1. **A learning project** — building practical fluency with Linux/Bash
2. **A technical showcase** — demonstrating scripting ability, attention to detail, and real-world problem solving

---

## ✅ Usage

All scripts are runnable directly from the terminal:

```bash
chmod +x script.sh
./script.sh [--dry-run] [args...]
