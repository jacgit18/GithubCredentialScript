#!/bin/bash

# Usage: ./setup_script.sh <GitHub Token>

TOKEN="$1"
CURRENT_USER=$(whoami)

# Set up Git credentials
git config --global credential.helper "store --file ~/.git-credentials"
echo "https://github.com:jacgit18:$TOKEN" >> ~/.git-credentials

# Add current user to cron allow list
sudo sh -c "echo '$CURRENT_USER' >> /etc/cron.allow"

# Restart cron service
sudo systemctl restart cron

# Search for sync.sh in the user's home directory and get the script's directory
SYNC_SCRIPT_DIR=$(find ~ -name "sync.sh" -exec dirname {} \; | head -n 1)

# Make the script executable (replace '#script' with your actual script filename)
sudo chmod +x "$SYNC_SCRIPT_DIR/sync.sh"

# Add cron job to run the script every 15 minutes (using the found script's directory)
(crontab -l ; echo "*/15 * * * * $SYNC_SCRIPT_DIR/sync.sh") | crontab -

