#!/usr/bin/env bash

# ===== Colors =====
BLUE="\033[1;34m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
RED="\033[1;31m"
RESET="\033[0m"

BASE_DIR="/home/vazoniaina/WINDOWS PARTITION/myLAB"

echo -e "${BLUE}Starting work environment pre-check...${RESET}"
echo

# ===== 1️⃣ Check Internet =====
echo -n "Checking Internet... "
if ping -c 1 8.8.8.8 >/dev/null 2>&1; then
  echo -e "${GREEN}OK${RESET}"
else
  echo -e "${RED}FAIL${RESET}"
fi

# ===== 2️⃣ Check Disk space =====
echo -n "Checking disk space (/home)... "
disk_avail=$(df -h /home | awk 'NR==2 {print $4}')
echo -e "${GREEN}$disk_avail available${RESET}"

# ===== 3️⃣ Check RAM =====
echo -n "Checking RAM... "
ram_free=$(free -h | awk '/^Mem:/ {print $7 " free"}')
echo -e "${GREEN}$ram_free${RESET}"

# ===== 4️⃣ Check CPU load =====
echo -n "Checking CPU load (1s average)... "
cpu_load=$(uptime | awk -F'load average:' '{print $2}' | cut -d, -f1)
echo -e "${GREEN}$cpu_load${RESET}"

# ===== 5️⃣ Check Battery (if exists) =====
if [ -d "/sys/class/power_supply/BAT0" ]; then
  echo -n "Checking battery... "
  bat_level=$(cat /sys/class/power_supply/BAT0/capacity)
  echo -e "${GREEN}$bat_level%${RESET}"
fi

echo
echo -e "${BLUE}Resource check complete.${RESET}"
echo

# ===== Existing project selection =====
if [ ! -d "$BASE_DIR" ]; then
  echo -e "${RED}Error: Projects directory not found.${RESET}"
  exit 1
fi

echo -e "${BLUE}Available projects:${RESET}"
echo

projects=()
i=1
for dir in "$BASE_DIR"/*; do
  if [ -d "$dir" ]; then
    name=$(basename "$dir")
    projects+=("$name")
    echo -e "${YELLOW}[$i]${RESET} $name"
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
  echo -e "${RED}Error: Project not found.${RESET}"
  exit 1
fi

echo
echo -e "${GREEN}Opening project:${RESET} $selected"

# ===== Open VS Code =====
if command -v code >/dev/null 2>&1; then
  code "$PROJECT_PATH" &
  echo -e "${GREEN}VS Code opened.${RESET}"
else
  echo -e "${RED}VS Code command not found.${RESET}"
fi

# ===== Open Brave =====
if command -v brave-browser >/dev/null 2>&1; then
  brave-browser &
  echo -e "${GREEN}Brave browser opened.${RESET}"
else
  echo -e "${RED}Brave browser not found.${RESET}"
fi

# ===== Open Spotify =====
echo -e "${BLUE}Starting Spotify...${RESET}"
if command -v spotify >/dev/null 2>&1; then
  spotify &
  echo -e "${GREEN}Spotify started.${RESET}"
elif command -v flatpak >/dev/null 2>&1 && flatpak list | grep -q com.spotify.Client; then
  flatpak run com.spotify.Client &
  echo -e "${GREEN}Spotify started (Flatpak).${RESET}"
else
  echo -e "${YELLOW}Spotify is not installed or not detected.${RESET}"
fi

echo
echo -e "${GREEN}Work environment is ready. Have a productive session!${RESET}"
