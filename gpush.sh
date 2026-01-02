#!/bin/bash

set -e
set -o pipefail

# Colors (only if output is a terminal)
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

# Check if inside a Git repository
if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
  echo -e "${RED}Error:${RESET} This directory is not a Git repository."
  exit 1
fi

# Check if remote 'origin' exists
if ! git remote | grep -q "^origin$"; then
  echo -e "${RED}Error:${RESET} No remote 'origin' found."
  exit 1
fi

# Get current branch
CURRENT_BRANCH=$(git branch --show-current)

if [[ -z "$CURRENT_BRANCH" ]]; then
  echo -e "${RED}Error:${RESET} Unable to determine the current branch."
  exit 1
fi

echo -e "${BLUE}Current branch:${RESET} ${BOLD}$CURRENT_BRANCH${RESET}"
echo ""

# Ask for the base branch for rebase
read -r -p "Enter the remote branch to rebase onto (e.g., dev, main): " BASE_BRANCH

if [[ -z "$BASE_BRANCH" ]]; then
  echo -e "${RED}Error:${RESET} Branch name cannot be empty."
  exit 1
fi

echo ""
echo -e "${YELLOW}Pulling with rebase from origin/${BASE_BRANCH}...${RESET}"
git pull --rebase origin "$BASE_BRANCH"
echo -e "${GREEN}Rebase completed successfully.${RESET}"
echo ""

# Check for changes
if [[ -z "$(git status --porcelain)" ]]; then
  echo -e "${YELLOW}No changes to commit.${RESET}"
  exit 0
fi

# Show status
echo -e "${BLUE}Repository status:${RESET}"
git status
echo ""

# Get commit message
read -r -p "Enter commit message: " COMMIT_MESSAGE

if [[ -z "$COMMIT_MESSAGE" ]]; then
  echo -e "${RED}Error:${RESET} Commit message cannot be empty."
  exit 1
fi

# Commit changes
echo ""
echo -e "${YELLOW}Creating commit...${RESET}"
git add .
git commit -m "$COMMIT_MESSAGE"

# Push to remote
echo ""
echo -e "${YELLOW}Pushing to origin/${CURRENT_BRANCH}...${RESET}"

if git rev-parse --abbrev-ref --symbolic-full-name "@{u}" > /dev/null 2>&1; then
  git push
else
  git push -u origin "$CURRENT_BRANCH"
fi

echo ""
echo -e "${GREEN}Success:${RESET} Commit and push completed on '${BOLD}$CURRENT_BRANCH${RESET}'."

