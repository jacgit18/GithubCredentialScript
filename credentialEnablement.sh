#!/bin/bash

# Usage: ./setup_script.sh <GitHub User> <GitHub Token> <Clone Directory>

GITHUB_USER="$1"
TOKEN="$2"
REPO_URL="https://github.com/jacgit18/NoteScriptSyncer.git"
CLONE_DIR="$3"
CURRENT_USER=$(whoami)

# Set up Git credentials
git config --global credential.helper "store --file ~/.git-credentials"
echo "https://github.com:$GITHUB_USER:$TOKEN" >> ~/.git-credentials

# Add current user to cron allow list
sudo sh -c "echo '$CURRENT_USER' >> /etc/cron.allow"

# Restart cron service
sudo systemctl restart cron

# Clone the Git repository into the specified directory
git clone "$REPO_URL" "$CLONE_DIR"

# Use the cloned directory for the SYNC_SCRIPT_DIR
SYNC_SCRIPT_DIR="$CLONE_DIR"

# Make the script executable (replace '#script' with your actual script filename)
sudo chmod +x "$SYNC_SCRIPT_DIR/sync.sh"

# Add cron job to run the script every 15 minutes (using the found script's directory)
(crontab -l ; echo "*/15 * * * * $SYNC_SCRIPT_DIR/sync.sh") | crontab -
