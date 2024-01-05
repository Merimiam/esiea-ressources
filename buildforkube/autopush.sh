#!/bin/bash

# Nom d'utilisateur Docker Hub
DOCKERHUB_USERNAME="melkhia"

# Nom du répertoire (généralement le nom du projet)
PROJECT_NAME=$(basename $(pwd))

# Services à construire et pousser
SERVICES=("worker" "vote" "seed-data" "result")

# Boucle sur chaque service
for SERVICE in "${SERVICES[@]}"; do
    # Construire l'image
    docker-compose build $SERVICE

    # Nom de l'image construite
    IMAGE_NAME="${PROJECT_NAME}_${SERVICE}"

    # Tagger l'image
    docker tag "$IMAGE_NAME:latest" "${DOCKERHUB_USERNAME}/${SERVICE}:latest"

    # Pousser l'image
    docker push "${DOCKERHUB_USERNAME}/${SERVICE}:latest"
done
