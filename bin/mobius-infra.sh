#!/bin/bash
export CLUSTER="mobius"
if [[ $# -eq 0 ]]; then
  echo "Parameters:"
  echo "==========="
  echo " - create: for installing k3d, terraform, and mobius cluster"
  echo " - remove: for removing mobius cluster"
else
  for option in "$@"; do
    if [[ $option == "create" ]]; then
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

        echo "Creating mobius cluster"
        k3d cluster create $CLUSTER -p "8900:30080@agent:0" -p "8901:30081@agent:0" -p "8902:30082@agent:0" --agents 2
        k3d kubeconfig get $CLUSTER > ~/.kube/config

    elif [[ $option == "remove" ]]; then
      echo "Removing mobius cluster"
      k3d cluster delete $CLUSTER
    else
      echo "($option) is not valid. Valid options are: create or remove."
    fi
  done
fi




