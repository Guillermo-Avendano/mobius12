#!/bin/bash

source "$kube_dir/common/local_registry.sh"

create_cluster(){
    info_message "Creating registry $MOBIUS_LOCALREGISTRY_NAME"
    k3d registry create $MOBIUS_LOCALREGISTRY_NAME --port 0.0.0.0:${MOBIUS_LOCALREGISTRY_PORT}

    info_message "Creating $KUBE_CLUSTER_NAME cluster..."

    KUBE_CLUSTER_REGISTRY="--registry-use k3d-$MOBIUS_LOCALREGISTRY_NAME:5000 --registry-config $kube_dir/common/registries.yaml"

    k3d cluster create $KUBE_CLUSTER_NAME -p "80:80@loadbalancer" -p "8900:30080@agent:0" -p "8901:30081@agent:0" -p "8902:30082@agent:0" --agents 2 --k3s-arg "--disable=traefik@server:0" $KUBE_CLUSTER_REGISTRY
    
    k3d kubeconfig get $KUBE_CLUSTER_NAME > ~/.kube/config
    kubectl config use-context k3d-$KUBE_CLUSTER_NAME
    
    # Getting Images
    # "$kube_dir/common/local_registry.sh"
    push_images_to_local_registry;

    # Install ingress
    kubectl create namespace ingress-nginx
    kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.0.3/deploy/static/provider/cloud/deploy.yaml -n ingress-nginx
}

remove_cluster() {
    info_message "Removing $KUBE_CLUSTER_NAME cluster..."
    k3d cluster delete $KUBE_CLUSTER_NAME
    k3d registry delete $MOBIUS_LOCALREGISTRY_NAME    
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

wait_cluster() {

    info_message "Waiting till all the k3d pods are Running..."

    while true
    do
        if kubectl get pod -kube-system | grep -E '^[^ ]+[ ]+[^ ]+[ ]+5/5[ ]+Running[ ]+' > /dev/null
        then
            break
        else
            kubectl get pod -kube-system
            info_message "k3d is starting, kube-system pods starting, please wait..."
            sleep 5
        fi
    done    

    while true
    do
        if kubectl get pod -n ingress-nginx | grep -E '^[^ ]+[ ]+[^ ]+[ ]+2/2[ ]+Completed[ ]+' > /dev/null
        then
            info_message "All the k3d pods are Running"
            break
        else
            kubectl get pod -n ingress-nginx
            info_message "k3d is starting, nginx pods starting, please wait..."
            sleep 5
        fi
    done 
}
