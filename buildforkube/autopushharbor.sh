#!/bin/bash

# Adresse du registre Harbor
HARBOR_REGISTRY="127.0.0.1"

# Nom d'utilisateur et mot de passe pour Harbor
HARBOR_USERNAME="admin"
HARBOR_PASSWORD="Root1231+"

# Nom du répertoire (généralement le nom du projet)
PROJECT_NAME=$(basename $(pwd))

# Services à construire et pousser
SERVICES=("worker" "vote" "seed-data" "result")

# Connexion au registre Harbor
echo $HARBOR_PASSWORD | docker login $HARBOR_REGISTRY -u $HARBOR_USERNAME --password-stdin

# Boucle sur chaque service
for SERVICE in "${SERVICES[@]}"; do
    # Construire l'image
    docker-compose build $SERVICE

    # Récupérer le nom de l'image construite
    # Assurez-vous que cette commande reflète le nom correct de vos images
    IMAGE_NAME=$(docker-compose images -q $SERVICE)

    # Vérifier si l'image existe
    if [ -z "$IMAGE_NAME" ]; then
        echo "Image pour le service $SERVICE introuvable. Vérifiez vos configurations Docker Compose."
        continue
    fi

    # Tagger l'image pour Harbor
    docker tag $IMAGE_NAME "${HARBOR_REGISTRY}/${PROJECT_NAME}/${SERVICE}:latest"

    # Pousser l'image sur Harbor
    docker push "${HARBOR_REGISTRY}/${PROJECT_NAME}/${SERVICE}:latest"
done
