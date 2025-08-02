#!/bin/bash

# Script : system-monitor.sh
# Objectif : alerte si RAM > 85%, batterie < 20%, ou température > 75°C
# Dépendances : notify-send, upower, free, sensors

# === RAM check ===
mem_used_percent=$(free | awk '/Mem:/ { printf("%.0f", $3/$2 * 100) }')
if [ "$mem_used_percent" -gt 85 ]; then
  notify-send "Memoara Alerita" "Efa mananika ny ${mem_used_percent}% ny fampiasan RAM anao"
fi

# === Battery check ===
battery_path=$(upower -e | grep battery | head -n 1)
battery_level=$(upower -i "$battery_path" | awk '/percentage:/ { gsub(/%/, "", $2); print $2 }')
if [ "$battery_level" -lt 20 ]; then
  notify-send "Vatoaratra Alerita" "Efa ambanin'ny ${battery_level}% ny tahan'ny vatoaratrao, atsatohy ny sarigera"
fi

# === Temperature check ===
# On récupère la température du CPU via sensors (ici Package id 0)
temp_value=$(sensors | grep 'Package id 0' | awk '{ gsub(/\+|°C/, "", $4); print int($4) }')

# Si capteur non trouvé, essaie autre chose :
if [ -z "$temp_value" ]; then
  temp_value=$(sensors | grep -m1 '°C' | awk '{ gsub(/\+|°C/, "", $2); print int($2) }')
fi

if [ "$temp_value" -gt 75 ]; then
  notify-send "Marimpana Alerita" "Afaka hitonoana hena ny hafanan'ny CPU anao efa mananika ny ${temp_value}°C ka tandremo!"
fi
