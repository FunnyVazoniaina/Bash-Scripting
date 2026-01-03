#!/usr/bin/env bash

# ===== Colors =====
BLUE="\033[1;34m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
RED="\033[1;31m"
RESET="\033[0m"

BASE_DIR="/home/vazoniaina/WINDOWS PARTITION/myLAB"

echo -e "${BLUE}Closing work environment...${RESET}"
echo

# ===== Check projects directory =====
if [ ! -d "$BASE_DIR" ]; then
  echo -e "${RED}Error: Projects directory not found.${RESET}"
  exit 1
fi

# ===== Git summary =====
echo -e "${BLUE}Git status summary:${RESET}"
echo

dirty_projects=0
clean_projects=0

for dir in "$BASE_DIR"/*; do
  if [ -d "$dir/.git" ]; then
    project=$(basename "$dir")
    cd "$dir" || continue

    if git diff --quiet && git diff --cached --quiet; then
      echo -e "${GREEN}✔ $project clean${RESET}"
      ((clean_projects++))
    else
      echo -e "${YELLOW}⚠ $project has uncommitted changes${RESET}"
      ((dirty_projects++))
    fi
  fi
done

echo
echo -e "${BLUE}Summary:${RESET}"
echo -e "Clean projects: ${GREEN}$clean_projects${RESET}"
echo -e "Projects with changes: ${YELLOW}$dirty_projects${RESET}"
echo

# ===== Close applications =====
echo -e "${BLUE}Stopping applications...${RESET}"

# VS Code
pkill -f code && echo -e "${GREEN}VS Code closed.${RESET}" || echo -e "${YELLOW}VS Code not running.${RESET}"

# Brave
pkill -f brave-browser && echo -e "${GREEN}Brave closed.${RESET}" || echo -e "${YELLOW}Brave not running.${RESET}"

# Spotify (native or Flatpak)
if pgrep -f com.spotify.Client >/dev/null; then
  pkill -f com.spotify.Client
  echo -e "${GREEN}Spotify closed.${RESET}"
elif pgrep -f spotify >/dev/null; then
  pkill -f spotify
  echo -e "${GREEN}Spotify closed.${RESET}"
else
  echo -e "${YELLOW}Spotify not running.${RESET}"
fi

echo
echo -e "${GREEN}Work session closed. See you tomorrow.${RESET}"
