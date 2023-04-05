#!/bin/bash

kube_init() {
  if [ "$ZENITH_KUBERNETES_TYPE" == "k3d" ]; then  
    KUBE_EXE="k3d"
    KUBE_CLI_EXE="kubectl"
    CONTAINER_EXE="docker"
  elif [ "$ZENITH_KUBERNETES_TYPE" == "rosa" ]; then
    KUBE_EXE=""
    KUBE_CLI_EXE="oc"
    CONTAINER_EXE="podman"    
  elif [ "$ZENITH_KUBERNETES_TYPE" == "okd" ]; then
    KUBE_EXE=""
    KUBE_CLI_EXE="oc"
    CONTAINER_EXE="podman"
  elif [ "$ZENITH_KUBERNETES_TYPE" == "crc" ]; then
    KUBE_EXE="crc"
    KUBE_CLI_EXE="oc"
    CONTAINER_EXE="podman"
  elif [ "$ZENITH_KUBERNETES_TYPE" == "eks" ]; then
    KUBE_EXE=""
    KUBE_CLI_EXE="kubectl"
    CONTAINER_EXE="docker"
  elif [ "$ZENITH_KUBERNETES_TYPE" == "minikube" ]; then
    KUBE_EXE="minikube"
    if ! command_exists $KUBE_EXE; then
      KUBE_EXE="k3d"
      KUBE_CLI_EXE="kubectl"
      CONTAINER_EXE="docker"
    fi
  fi
}

check_cluster_exists() {
    #TODO: Needed to add minikube
    $KUBE_EXE cluster list 2>/dev/null | grep -q "$KUBE_CLUSTER_NAME"
}

get_kubeconfig() {
  if [ "$ZENITH_KUBERNETES_TYPE" == "k3d" ]; then
    $KUBE_EXE kubeconfig get $KUBE_CLUSTER_NAME 2>/dev/null
  elif [ "$ZENITH_KUBERNETES_TYPE" == "minikube" ]; then
    cat ~/.minikube/profiles/config.json 2>/dev/null
  elif [ "$ZENITH_KUBERNETES_TYPE" == "crc" ]; then
    $KUBE_CLI_EXE config view --raw 2>/dev/null;
  fi
}

save_kubeconfig() {
  if [ "$ZENITH_KUBERNETES_TYPE" == "k3d" ]; then
    $KUBE_EXE kubeconfig get $KUBE_CLUSTER_NAME >"$(pwd)/zenith-kubeconfig"
  elif [ "$ZENITH_KUBERNETES_TYPE" == "minikube" ]; then
    cp ~/.minikube/profiles/$KUBE_CLUSTER_NAME/config.json "$(pwd)/zenith-kubeconfig"
  elif [ "$ZENITH_KUBERNETES_TYPE" == "crc" ]; then
    $KUBE_CLI_EXE config view --raw >"$(pwd)/zenith-kubeconfig";
  fi
}

check_cluster_connection() {
  export KUBECONFIG=$ZENITH_KUBECONFIG
  info_message "Showing some cluster info:"
  $KUBE_CLI_EXE cluster-info 
}

cluster_connection() {
  kc=$(get_kubeconfig)
  [ -n "$kc" ] || abort "could not obtain a valid KUBECONFIG from $ZENITH_KUBERNETES_TYPE"
  save_kubeconfig;

  ZENITH_KUBECONFIG="$(pwd)/zenith-kubeconfig"
  check_cluster_connection;
}

export_cluster_config() {
  cluster_connection;
}

create_cluster() {
  info_message "Creating kubernetes cluster $KUBE_CLUSTER_NAME"

  if [ "$ZENITH_REGISTRY_TYPE" == "local" ]; then
    if [ "$ZENITH_KUBERNETES_TYPE" == "k3d" ]; then
      echo $KUBE_EXE cluster create ${KUBE_CLUSTER_NAME} --agents $KUBE_NUM_AGENTS $KUBE_ARGS $KUBE_REGISTRY --k3s-arg "--disable=traefik@server:0"
      $KUBE_EXE cluster create ${KUBE_CLUSTER_NAME} --agents $KUBE_NUM_AGENTS $KUBE_ARGS $KUBE_REGISTRY --k3s-arg "--disable=traefik@server:0"
    elif [ "$ZENITH_KUBERNETES_TYPE" == "minikube" ]; then
      echo $KUBE_EXE start -p ${KUBE_CLUSTER_NAME} $KUBE_NUM_AGENTS $KUBE_ARGS $KUBE_REGISTRY --k3s-arg "--disable=traefik@server:0"
      #TODO: Needed to add full minikube settings (ports...)
      $KUBE_EXE start -p ${KUBE_CLUSTER_NAME}
    fi
  else
    if [ "$ZENITH_KUBERNETES_TYPE" == "k3d" ]; then
      echo $KUBE_EXE cluster create ${KUBE_CLUSTER_NAME} --agents $KUBE_NUM_AGENTS $KUBE_ARGS --k3s-arg "--disable=traefik@server:0"
      $KUBE_EXE cluster create ${KUBE_CLUSTER_NAME} --agents $KUBE_NUM_AGENTS $KUBE_ARGS --k3s-arg "--disable=traefik@server:0"
    elif [ "$ZENITH_KUBERNETES_TYPE" == "minikube" ]; then
      echo $KUBE_EXE start -p ${KUBE_CLUSTER_NAME} $KUBE_NUM_AGENTS $KUBE_ARGS --k3s-arg "--disable=traefik@server:0"
      #TODO: Needed to add full minikube settings (ports...)
      $KUBE_EXE start -p ${KUBE_CLUSTER_NAME}
    fi
  fi

  sleep 3
  cluster_connection;
}

kube_delete_cluster() {
  if [ "$ZENITH_KUBERNETES_TYPE" == "k3d" ]; then
    $KUBE_EXE cluster delete $1
  elif [ "$ZENITH_KUBERNETES_TYPE" == "crc" ]; then
    $KUBE_EXE stop
    $KUBE_EXE delete
  else
    $KUBE_EXE stop -p $1
    $KUBE_EXE delete -p $1
  fi
}

create_local_cluster() {
  kube_init
  info_message "Checking if kubernetes provider is installed"

  if ! command_exists $KUBE_EXE; then
    info_message "Kubernetes provider isn't installed. Please, install it and re-run"
    exit 1

    #automate the crc installation

  else
    info_message "Kubernetes provider seems to be installed"
  fi

  info_message "Local registry management"

  create_registry;
  push_images_to_local_registry;

  info_message "Creating $KUBE_CLUSTER_NAME cluster"

  if check_cluster_exists; then
    info_message "Cluster $KUBE_CLUSTER_NAME already exists"
    cluster_connection;
  else
    create_cluster;
  fi
}
