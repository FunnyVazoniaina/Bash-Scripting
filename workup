#!/usr/bin/env bash

# ---------- Colors ----------
BLUE="\033[1;34m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
RED="\033[1;31m"
RESET="\033[0m"

# ---------- Config ----------
BASE_DIR="/home/vazoniaina/WINDOWS PARTITION/myLAB"

# ---------- Check base directory ----------
if [ ! -d "$BASE_DIR" ]; then
  echo -e "${RED}Error:${RESET} Projects directory not found:"
  echo "$BASE_DIR"
  exit 1
fi

echo -e "${BLUE}Available projects:${RESET}\n"

projects=()
i=1

for dir in "$BASE_DIR"/*; do
  if [ -d "$dir" ]; then
    name=$(basename "$dir")
    projects+=("$name")
    echo -e "  ${YELLOW}[$i]${RESET} $name"
    ((i++))
  fi
done

echo
read -p "Enter project number or project name: " choice

selected=""

if [[ "$choice" =~ ^[0-9]+$ ]]; then
  index=$((choice - 1))
  selected="${projects[$index]}"
else
  selected="$choice"
fi

PROJECT_PATH="$BASE_DIR/$selected"

if [ ! -d "$PROJECT_PATH" ]; then
  echo -e "${RED}Error:${RESET} Project not found: $selected"
  exit 1
fi

echo
echo -e "${GREEN}Opening project:${RESET} $selected"

# ---------- Open VS Code ----------
echo -e "${YELLOW}Launching VS Code...${RESET}"
code "$PROJECT_PATH" &

# ---------- Open Browser ----------
echo -e "${YELLOW}Launching Brave browser...${RESET}"
brave-browser &

# ---------- Open Spotify ----------
echo -e "${YELLOW}Launching Spotify...${RESET}"
if flatpak list | grep -q com.spotify.Client; then
  flatpak run com.spotify.Client &
else
  echo -e "${RED}Warning:${RESET} Spotify is not installed (Flatpak not found)"
fi

echo
echo -e "${GREEN}Workspace is ready. Have a productive session.${RESET}"
