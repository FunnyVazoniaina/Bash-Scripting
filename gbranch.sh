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

# Check Git repository
if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
  echo -e "${RED}Error:${RESET} This directory is not a Git repository."
  exit 1
fi

# Check remote
if ! git remote | grep -q "^origin$"; then
  echo -e "${RED}Error:${RESET} No remote 'origin' found."
  exit 1
fi

# Ensure clean working tree
if [[ -n "$(git status --porcelain)" ]]; then
  echo -e "${RED}Error:${RESET} You have uncommitted changes."
  echo -e "${YELLOW}Please commit or stash them before creating a branch.${RESET}"
  git status
  exit 1
fi

# Ask base branch
read -r -p "Base branch (e.g. dev, main): " BASE_BRANCH
if [[ -z "$BASE_BRANCH" ]]; then
  echo -e "${RED}Error:${RESET} Base branch cannot be empty."
  exit 1
fi

# Update base branch
echo -e "${YELLOW}Checking out ${BASE_BRANCH}...${RESET}"
git checkout "$BASE_BRANCH"

echo -e "${YELLOW}Rebasing from origin/${BASE_BRANCH}...${RESET}"
git pull --rebase origin "$BASE_BRANCH"
echo -e "${GREEN}Base branch is up to date.${RESET}"
echo ""

# Prefix selection
echo -e "${BLUE}Select branch prefix:${RESET}"
echo " 1) feature"
echo " 2) fix"
echo " 3) hotfix"
echo " 4) release"
echo " 5) chore"
echo " 6) refactor"
echo " 7) test"
echo " 8) docs"
echo " 9) ci"
echo "10) perf"
echo "11) style"
echo "12) build"

read -r -p "Choice (1-12): " PREFIX_CHOICE

case "$PREFIX_CHOICE" in
  1) PREFIX="feature" ;;
  2) PREFIX="fix" ;;
  3) PREFIX="hotfix" ;;
  4) PREFIX="release" ;;
  5) PREFIX="chore" ;;
  6) PREFIX="refactor" ;;
  7) PREFIX="test" ;;
  8) PREFIX="docs" ;;
  9) PREFIX="ci" ;;
 10) PREFIX="perf" ;;
 11) PREFIX="style" ;;
 12) PREFIX="build" ;;
  *) echo -e "${RED}Error:${RESET} Invalid choice."; exit 1 ;;
esac

# Branch name
read -r -p "Branch name (e.g. login-form): " BRANCH_NAME
if [[ -z "$BRANCH_NAME" ]]; then
  echo -e "${RED}Error:${RESET} Branch name cannot be empty."
  exit 1
fi

NEW_BRANCH="${PREFIX}/${BRANCH_NAME}"

# Create branch
echo -e "${YELLOW}Creating branch ${NEW_BRANCH}...${RESET}"
git checkout -b "$NEW_BRANCH"

# Push branch
echo -e "${YELLOW}Pushing branch and setting upstream...${RESET}"
git push -u origin "$NEW_BRANCH"

echo -e "${GREEN}Success:${RESET} Branch ${BOLD}${NEW_BRANCH}${RESET} created and ready."
