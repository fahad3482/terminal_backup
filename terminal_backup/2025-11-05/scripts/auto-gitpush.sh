#!/bin/bash
# 🧬 Clean & Structured Terminal Backup Script — by Fahad

BASE_DIR="terminal_backup"
GITHUB_SSH_URL="git@github.com:fahad3482/terminal_backup.git"

mkdir -p "$BASE_DIR"

# Ensure inside a Git repo
if [ ! -d .git ]; then
    echo "❌ Not a Git repo! Run 'git init' first."
    exit 1
fi

# Set Git SSH remote if needed
CURRENT_REMOTE=$(git remote get-url origin 2>/dev/null)
if [ "$CURRENT_REMOTE" != "$GITHUB_SSH_URL" ]; then
    git remote remove origin 2>/dev/null
    git remote add origin "$GITHUB_SSH_URL"
    echo "🔗 Git remote set to SSH"
fi

# ----------------------------
# Session Recording
# ----------------------------
DATE_DIR="$BASE_DIR/$(date +%F)"
mkdir -p "$DATE_DIR/scripts" "$DATE_DIR/files"

SESSION_TS=$(date '+%F_%H-%M-%S')
SESSION_RAW="$DATE_DIR/session_raw_$SESSION_TS.log"
SESSION_CLEAN="$DATE_DIR/session_$SESSION_TS.log"

echo "📝 Recording session..."
# Record session
script -q -f "$SESSION_RAW"

# Clean the log (strip escape codes)
cat "$SESSION_RAW" | col -b > "$SESSION_CLEAN"
rm "$SESSION_RAW"  # optional

# ----------------------------
# Copy scripts & files
# ----------------------------
echo "📝 Copying new Bash scripts..."
find . -maxdepth 1 -type f -name "*.sh" -exec cp {} "$DATE_DIR/scripts/" \;

echo "📝 Copying text files..."
find . -maxdepth 1 -type f -name "*.txt" -exec cp {} "$DATE_DIR/files/" \;

# ----------------------------
# Git Operations
# ----------------------------
git pull --rebase origin main 2>/dev/null || echo "⚠️ No remote branch yet or first commit."
git add -A "$BASE_DIR"
COMMIT_MSG="Auto backup: $SESSION_TS"
git commit -m "$COMMIT_MSG" 2>/dev/null || echo "⚠️ Nothing new to commit."
git push origin main

echo "✅ Backup done: session & scripts organized by date!"

