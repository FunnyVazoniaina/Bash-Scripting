#!/bin/bash

# Script : ytd-mp3
# Description : Télécharge l'audio d'une vidéo YouTube au format MP3
# Dépendances : yt-dlp et ffmpeg doivent être installés
# Utilisation : ytd-mp3 <url_de_la_video>

# Vérifie si un lien est fourni
if [ -z "$1" ]; then
  echo "❌ Erreur : Aucun lien fourni."
  echo "✅ Utilisation : ytd-mp3 <url_de_la_video>"
  exit 1
fi

# Vérifie si yt-dlp est installé
if ! command -v yt-dlp &> /dev/null; then
  echo "❌ Erreur : yt-dlp n'est pas installé. Installe-le avec : pip3 install yt-dlp --user"
  exit 1
fi

# Vérifie si ffmpeg est installé
if ! command -v ffmpeg &> /dev/null; then
  echo "❌ Erreur : ffmpeg n'est pas installé. Installe-le avec : sudo dnf install ffmpeg"
  exit 1
fi

# Télécharge l'audio au format MP3
echo "🎧 Téléchargement de l'audio MP3 en cours..."
yt-dlp -x --audio-format mp3 "$@"
echo "✅ Terminé !"

