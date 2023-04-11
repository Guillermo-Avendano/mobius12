#!/bin/bash

xargsflag="-d"
if [ $(uname -s) == "Darwin" ]; then
 xargsflag="-I"
fi
export $(cat .env | egrep -v "(^#.*|^$)" | xargs)
kube_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
[ -d "$kube_dir" ] || {
    echo "FATAL: no current dir (maybe running in zsh?)"
    exit 1
}

source "$kube_dir/common/common.sh"
source "$kube_dir/common/local_registry.sh"

if [[ $# -eq 0 ]]; then
  echo "Parameters:"
  echo "==========="
  echo " - on      : starts mobius cluster"
  echo " - off     : stops mobius cluster"
  echo " - install : k3d, terraform"
  echo " - create  : create mobius cluster"
  echo " - remove  : remove mobius cluster"
else
  for option in "$@"; do
    if [[ $option == "install" ]]; then
        # Install NFS
        # sudo apt-get update
        # sudo apt-get install nfs-kernel-server
        # sudo mkdir -p /mnt/nfs
        # sudo chown nobody:nogroup /mnt/nfs
        # sudo chmod 777 /mnt/nfs
        # /mnt/nfs  *(rw,sync,no_subtree_check,no_root_squash)
        # sudo systemctl restart nfs-kernel-server

        # install k3d
        curl -s https://raw.githubusercontent.com/rancher/k3d/main/install.sh | TAG=v5.4.6 bash

        # install kubectl
        curl -o kubectl https://s3.us-west-2.amazonaws.com/amazon-eks/1.22.17/2023-01-30/bin/linux/amd64/kubectl
        chmod +x kubectl
        sudo mv kubectl /usr/local/bin/kubectl

        #Install helm (from https://helm.sh/docs/intro/install/)
        export DESIRED_VERSION=v3.8.2
        curl -s https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

        #Install docker-compose
        sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
        sudo chmod +x /usr/local/bin/docker-compose
        
        # Install Terraform
        sudo apt install -y gnupg software-properties-common curl
        curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
        sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
        sudo apt update && sudo apt install terraform

    elif [[ $option == "create" ]]; then
        echo "Creating mobius cluster"

        k3d cluster create $KUBE_CLUSTER_NAME -p "80:80@loadbalancer" -p "8900:30080@agent:0" -p "8901:30081@agent:0" -p "8902:30082@agent:0" --agents 2 --k3s-arg "--disable=traefik@server:0"
        
        k3d kubeconfig get $KUBE_CLUSTER_NAME > ~/.kube/config
        kubectl config use-context k3d-$KUBE_CLUSTER_NAME

        info_message "Creating registry $MOBIUS_LOCALREGISTRY_NAME:$MOBIUS_LOCALREGISTRY_PORT"
        k3d registry create $MOBIUS_LOCALREGISTRY_NAME --port 0.0.0.0:${MOBIUS_LOCALREGISTRY_PORT}
        
        # Getting Images
        push_images_to_local_registry;

        # Install ingress
        kubectl create namespace ingress-nginx
        kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.0.3/deploy/static/provider/cloud/deploy.yaml -n ingress-nginx


    elif [[ $option == "remove" ]]; then
      echo "Removing mobius cluster"
      k3d cluster delete $KUBE_CLUSTER_NAME
      k3d registry delete k3d-$MOBIUS_LOCALREGISTRY_NAME

    elif [[ $option == "on" ]]; then
      echo "Starting mobius cluster"
      k3d cluster start $KUBE_CLUSTER_NAME 
      kubectl config use-context k3d-$KUBE_CLUSTER_NAME

    elif [[ $option == "off" ]]; then
      echo "Stopping mobius cluster"
      k3d cluster stop $KUBE_CLUSTER_NAME

    else
      echo "($option) is not valid. Valid options are: create or remove."
    fi
  done
fi





