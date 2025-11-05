#!/bin/bash
# 🧬 Fully Automated Terminal & Script Backup with SSH — by Fahad

# ----------------------------
# CONFIGURATION
# ----------------------------
# Folder to store all logs and scripts
BASE_DIR="terminal_backup"

# Your GitHub repository SSH URL
# Replace this with your actual GitHub SSH repo
GITHUB_SSH_URL="git@github.com:fahad3482/terminal_backup.git"

# ----------------------------
# SETUP
# ----------------------------
mkdir -p "$BASE_DIR"

# Check if inside a Git repository
if [ ! -d .git ]; then
    echo "❌ Not a Git repository! Run 'git init' first."
    exit 1
fi

# Ensure Git remote is set to the correct SSH
CURRENT_REMOTE=$(git remote get-url origin 2>/dev/null)
if [ "$CURRENT_REMOTE" != "$GITHUB_SSH_URL" ]; then
    git remote remove origin 2>/dev/null
    git remote add origin "$GITHUB_SSH_URL"
    echo "🔗 Git remote set to SSH: $GITHUB_SSH_URL"
fi

# ----------------------------
# START SESSION RECORDING
# ----------------------------
# Create folder for today's date
DATE_DIR="$BASE_DIR/$(date +%F)"
mkdir -p "$DATE_DIR/scripts"

# Timestamp for this session
SESSION_TS=$(date '+%F_%H-%M-%S')
SESSION_FILE="$DATE_DIR/session_$SESSION_TS.log"

echo "📝 Starting terminal session recording..."
echo "   (Type 'exit' or Ctrl+D to end the session)"
# Record all terminal activity
script -q -f "$SESSION_FILE"

# ----------------------------
# ORGANIZE SCRIPTS
# ----------------------------
echo "📝 Copying new Bash scripts..."
# Copy all .sh files in the current folder into today's scripts folder
find . -maxdepth 1 -type f -name "*.sh" -exec cp {} "$DATE_DIR/scripts/" \;

# ----------------------------
# GIT OPERATIONS
# ----------------------------
echo "📥 Pulling latest changes..."
git pull --rebase origin main 2>/dev/null || echo "⚠️ No remote branch yet or first commit."

echo "🧩 Adding backup files..."
git add -A "$BASE_DIR"

COMMIT_MSG="Auto backup: $SESSION_TS"
echo "🧠 Committing with message: $COMMIT_MSG"
git commit -m "$COMMIT_MSG" 2>/dev/null || echo "⚠️ Nothing new to commit."

echo "🚀 Pushing to GitHub via SSH..."
git push origin main

if [ $? -eq 0 ]; then
    echo "✅ Backup successful — all sessions and scripts saved in GitHub!"
else
    echo "⚠️ Push failed. Check your SSH key or GitHub repository."
fi

