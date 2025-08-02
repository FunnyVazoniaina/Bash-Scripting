#!/bin/bash

# Script : update-all
# Description : Met à jour tous les paquets du système (DNF, Flatpak)
# Utilisation : update-all

echo "📦 Mise à jour de DNF (paquets classiques Fedora)..."
sudo dnf upgrade --refresh -y

echo "📦 Mise à jour des paquets Flatpak..."
flatpak update -y

# Si tu utilises d'autres gestionnaires comme snap, ajoute ici :
# echo "📦 Mise à jour des paquets Snap..."
# sudo snap refresh

echo "✅ Mise à jour complète terminée !"
