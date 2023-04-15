#!/bin/bash

source "$kube_dir/cluster/local_registry.sh"
source "$kube_dir/common/common.sh"

create_cluster(){
    info_message "Creating registry $KUBE_LOCALREGISTRY_NAME"
    k3d registry create $KUBE_LOCALREGISTRY_NAME --port 0.0.0.0:${KUBE_LOCALREGISTRY_PORT}

    info_message "Creating $KUBE_CLUSTER_NAME cluster..."

    KUBE_CLUSTER_REGISTRY="--registry-use k3d-$KUBE_LOCALREGISTRY_NAME:5000 --registry-config $kube_dir/cluster/registries.yaml"

    k3d cluster create $KUBE_CLUSTER_NAME -p "80:80@loadbalancer" -p "8900:30080@agent:0" -p "8901:30081@agent:0" -p "8902:30082@agent:0" --agents 2 --k3s-arg "--disable=traefik@server:0" $KUBE_CLUSTER_REGISTRY
    
    k3d kubeconfig get $KUBE_CLUSTER_NAME > $kube_dir/cluster/cluster-config.yaml

    kubectl config use-context k3d-$KUBE_CLUSTER_NAME
    
    # Getting Images
    # "$kube_dir/cluster/local_registry.sh"
    push_images_to_local_registry;

    # Install ingress
    kubectl create namespace ingress-nginx
    kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.0.3/deploy/static/provider/cloud/deploy.yaml -n ingress-nginx
}

remove_cluster() {
    info_message "Removing $KUBE_CLUSTER_NAME cluster..."
    k3d cluster delete $KUBE_CLUSTER_NAME
    k3d registry delete $KUBE_LOCALREGISTRY_NAME    
    docker network rm k3d-$KUBE_CLUSTER_NAME
}

start_cluster() {
    info_message "Starting $KUBE_CLUSTER_NAME cluster..."
    k3d cluster start $KUBE_CLUSTER_NAME 
    kubectl config use-context k3d-$KUBE_CLUSTER_NAME    
}

stop_cluster() {
    info_message "Stopping $KUBE_CLUSTER_NAME cluster"
    k3d cluster stop $KUBE_CLUSTER_NAME
}

list_cluster() {
    info_message "Cluster's list"
    k3d cluster list
}