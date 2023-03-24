#!/usr/bin/env bash

# Set your GitHub repository URL and branch name
GITHUB_REPO_URL="CHANGE_THIS"
BRANCH_NAME="CHANGE_THIS"

# Set the path where you want to clone the repository
REPO_PATH="CHANGE_THIS"

# Set your Telegram API token and chat ID
# TELEGRAM_API_TOKEN you can get from @BotFather
# TELEGRAM_CHAT_ID you can get from @RawDataBot
TELEGRAM_TOKEN="CHANGE_THIS"
TELEGRAM_CHAT_ID="CHANGE_THIS"

# Clone the repository if doesn't exist
#
if [ ! -d $REPO_PATH ]; then
    git clone --branch $BRANCH_NAME $GITHUB_REPO_URL $REPO_PATH
fi

# Check for updates
cd $REPO_PATH
git fetch origin $BRANCH_NAME
LOCAL=$(git rev-parse HEAD)
REMOTE=$(git ls-remote --heads "$GITHUB_REPO_URL" "$BRANCH_NAME" | cut -f1)

    if [ $LOCAL != $REMOTE ]; then

    # Update local repo with remote changes
    git pull origin $BRANCH_NAME

    # Extract all URLs from the config file
    URLS=$(jq -r '.. | strings | select(startswith("http://") or startswith("https://"))' CHANGE_THIS_TO_FILE_FOR_PARSING | uniq)

    # Send the changes to Telegram
    MESSAGE="Targets updated, now under DDoS:\n\n$URLS"
    curl -s -X POST -H 'Content-Type: application/json' -d '{"chat_id":"'$TELEGRAM_CHAT_ID'","text":"'"$MESSAGE"'"}' "https://api.telegram.org/bot$TELEGRAM_TOKEN/sendMessage" > /dev/null

fi
