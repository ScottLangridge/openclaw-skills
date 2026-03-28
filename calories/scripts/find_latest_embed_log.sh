#!/usr/bin/env bash
# Returns the path to the most recent EMBED Journal log file (top-level only)
JOURNAL_DIR="/home/node/scotts-data/obsidian-vaults/scotts-vault/Projects/EMBED Study/Journal"
find "$JOURNAL_DIR" -maxdepth 1 -name "*.md" -type f | sort | tail -1
