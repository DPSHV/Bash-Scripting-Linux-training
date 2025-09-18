# 📘 Bash + Linux Admin Scripts (Learning Edition)

A curated collection of Bash scripts built step-by-step while learning Linux system administration and scripting fundamentals.

This repo grows daily — each script reflects a specific learning milestone, focusing on clarity, structure, and real-world utility.

## 🚀 Goals

- Learn by doing — each script solves a real admin task
- Practice writing clean, modular, and safe Bash
- Understand Linux tools, logs, permissions, filesystems, and processes
- Build habits for production-grade scripting early on

## 📂 Current Scripts

| Script                 | Purpose                                          |
|------------------------|--------------------------------------------------|
| `user_process_report.sh` | List and count all user processes             |
| `files_linecount.sh`     | Sum up total line count across input files     |
| `txt_backup.sh`          | Backup non-empty `.txt` files with date suffix |
| `find_uniq_errors.sh`    | Extract and deduplicate log errors             |

Each script includes:
- Input validation
- Logging functions
- Clean code style with comments
- Optional flags (e.g. `--dry-run`, `--help`)

## 🧠 Usage (for practice)

```bash
chmod +x script.sh
./script.sh [--dry-run] [args...]
