#!/bin/bash

# Repositorio Docker privado
DOCKER_REGISTRY="<nombre_del_repositorio>"

# Cluster K3d
K3D_CLUSTER="<nombre_del_cluster>"
K3D_NAMESPACE="<nombre_del_namespace>"

# Imágenes a descargar, etiquetar y subir
IMAGES=("imagen1" "imagen2" "imagen3")
TAG="latest"

# Inicia sesión en el repositorio Docker privado
docker login $DOCKER_REGISTRY

# Descarga, etiqueta y sube las imágenes
for IMAGE in "${IMAGES[@]}"
do
  # Descarga la imagen
  docker pull $DOCKER_REGISTRY/$IMAGE:$TAG

  # Etiqueta la imagen
  docker tag $DOCKER_REGISTRY/$IMAGE:$TAG localhost:5000/$IMAGE:$TAG

  # Inicia sesión en el registro del cluster K3d
  kubectl config set-context k3d-$K3D_CLUSTER --namespace=$K3D_NAMESPACE
  k3d image import localhost:5000/$IMAGE:$TAG

  # Sube la imagen al registro del cluster K3d
  docker push localhost:5000/$IMAGE:$TAG
done

