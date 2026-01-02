#!/bin/bash

set -e
set -o pipefail

# Colors
if [[ -t 1 ]]; then
  RED="\e[31m"
  GREEN="\e[32m"
  YELLOW="\e[33m"
  BLUE="\e[34m"
  BOLD="\e[1m"
  RESET="\e[0m"
else
  RED=""
  GREEN=""
  YELLOW=""
  BLUE=""
  BOLD=""
  RESET=""
fi

# Check repository
if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
  echo -e "${RED}Error:${RESET} This directory is not a Git repository."
  exit 1
fi

# Check remote
if ! git remote | grep -q "^origin$"; then
  echo -e "${RED}Error:${RESET} No remote 'origin' found."
  exit 1
fi

# Current branch
CURRENT_BRANCH=$(git branch --show-current)
if [[ -z "$CURRENT_BRANCH" ]]; then
  echo -e "${RED}Error:${RESET} Unable to determine the current branch."
  exit 1
fi
echo -e "${BLUE}Current branch:${RESET} ${BOLD}$CURRENT_BRANCH${RESET}"
echo ""

# Check for unstaged changes
if [[ -n "$(git status --porcelain)" ]]; then
  echo -e "${YELLOW}You have unstaged changes.${RESET}"
  git status
  echo ""
  read -r -p "Do you want to commit them before pull? (y/n) " COMMIT_CHOICE
  if [[ "$COMMIT_CHOICE" == "y" || "$COMMIT_CHOICE" == "Y" ]]; then
    read -r -p "Enter commit message: " COMMIT_MESSAGE
    if [[ -z "$COMMIT_MESSAGE" ]]; then
      echo -e "${RED}Error:${RESET} Commit message cannot be empty."
      exit 1
    fi
    git add .
    git commit -m "$COMMIT_MESSAGE"
    echo -e "${GREEN}Changes committed.${RESET}"
  else
    echo -e "${RED}Aborting pull because of unstaged changes.${RESET}"
    exit 1
  fi
fi

# Ask for base branch for rebase
read -r -p "Enter the remote branch to rebase onto (e.g., dev, main): " BASE_BRANCH
if [[ -z "$BASE_BRANCH" ]]; then
  echo -e "${RED}Error:${RESET} Branch name cannot be empty."
  exit 1
fi

# Pull with rebase
echo -e "${YELLOW}Pulling with rebase from origin/${BASE_BRANCH}...${RESET}"
git pull --rebase origin "$BASE_BRANCH"
echo -e "${GREEN}Rebase completed successfully.${RESET}"
echo ""

# Check for new changes after rebase
if [[ -z "$(git status --porcelain)" ]]; then
  echo -e "${YELLOW}No changes to commit.${RESET}"
else
  # Commit any remaining changes if needed
  git status
  echo -e "${YELLOW}You have changes after rebase. Commit them if needed.${RESET}"
fi

# Push to remote
echo -e "${YELLOW}Pushing to origin/${CURRENT_BRANCH}...${RESET}"
if git rev-parse --abbrev-ref --symbolic-full-name "@{u}" > /dev/null 2>&1; then
  git push
else
  git push -u origin "$CURRENT_BRANCH"
fi

echo -e "${GREEN}Success:${RESET} Commit and push completed on '${BOLD}$CURRENT_BRANCH${RESET}'."
