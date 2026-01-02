#!/bin/bash

# Arrêter le script en cas d'erreur
set -e
set -o pipefail

# Vérifier qu'on est dans un dépôt Git
if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
  echo "Erreur : ce répertoire n'est pas un dépôt Git."
  exit 1
fi

# Vérifier s'il y a des changements
if [[ -z "$(git status --porcelain)" ]]; then
  echo "Aucun changement à commit."
  exit 0
fi

# Afficher l'état du dépôt
git status
echo ""

# Demander le message de commit
read -r -p "Message de commit : " COMMIT_MESSAGE

if [[ -z "$COMMIT_MESSAGE" ]]; then
  echo "Erreur : le message de commit est vide."
  exit 1
fi

# Ajouter les fichiers
git add .

# Créer le commit
git commit -m "$COMMIT_MESSAGE"

# Récupérer la branche courante
CURRENT_BRANCH=$(git branch --show-current)

if [[ -z "$CURRENT_BRANCH" ]]; then
  echo "Erreur : impossible de déterminer la branche courante."
  exit 1
fi

# Vérifier que le remote origin existe
if ! git remote | grep -q "^origin$"; then
  echo "Erreur : aucun remote 'origin' trouvé."
  exit 1
fi

# Push (avec gestion du premier push)
if git rev-parse --abbrev-ref --symbolic-full-name "@{u}" > /dev/null 2>&1; then
  git push
else
  git push -u origin "$CURRENT_BRANCH"
fi

echo "Commit et push effectués sur la branche '$CURRENT_BRANCH'."
