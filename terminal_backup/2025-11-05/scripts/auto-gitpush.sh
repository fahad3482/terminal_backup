#!/bin/bash
# 🧬 Fully Automated Terminal & Script Backup with Date Organization — by Fahad

# Base backup folder
BASE_DIR="terminal_backup"
mkdir -p "$BASE_DIR"

# Check Git repo
if [ ! -d .git ]; then
    echo "❌ Not a Git repository! Run 'git init' first."
    exit 1
fi

# Create folder for today’s date
DATE_DIR="$BASE_DIR/$(date +%F)"
mkdir -p "$DATE_DIR/scripts"

# Timestamp for this session
SESSION_TS=$(date '+%F_%H-%M-%S')
SESSION_FILE="$DATE_DIR/session_$SESSION_TS.log"

# Start recording all terminal activity
# Everything typed and output is saved in SESSION_FILE
echo "📝 Starting terminal session recording..."
script -q -f "$SESSION_FILE"

# After exit: organize scripts (optional: copy all .sh files to today's folder)
echo "📝 Organizing Bash scripts..."
find . -maxdepth 1 -type f -name "*.sh" -exec cp {} "$DATE_DIR/scripts/" \;

# Git operations
echo "📥 Pulling latest changes..."
git pull --rebase

echo "🧩 Adding backup files..."
git add -A "$BASE_DIR"

COMMIT_MSG="Auto backup: $SESSION_TS"
echo "🧠 Committing with message: $COMMIT_MSG"
git commit -m "$COMMIT_MSG"

echo "🚀 Pushing to GitHub..."
git push

if [ $? -eq 0 ]; then
    echo "✅ Backup successful — all sessions and scripts saved in GitHub!"
else
    echo "⚠️ Push failed. Check your connection or repo permissions."
fi
