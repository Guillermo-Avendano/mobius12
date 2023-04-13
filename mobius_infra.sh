#!/bin/bash

kube_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
[ -d "$kube_dir" ] || {
    echo "FATAL: no current dir (maybe running in zsh?)"
    exit 1
}

source "$kube_dir/common/env.sh"
source "$kube_dir/common/common.sh"
source "$kube_dir/common/cluster.sh"
source "$kube_dir/common/kubernetes.sh"
source "$kube_dir/common/local_registry.sh"

if [[ $# -eq 0 ]]; then
  echo "Parameters:"
  echo "==========="
  echo " - on      : starts mobius cluster"
  echo " - off     : stops mobius cluster"
  echo " - create  : create mobius cluster"
  echo " - remove  : remove mobius cluster"
  echo " - install : k3d, kubectl, helm, and terraform"
  echo " - docker  : install docker (testing)"
else
  for option in "$@"; do
    if [[ $option == "install" ]]; then

        # install k3d 
        # common/kubernetes.sh
        install_k3d;

        # install kubectl
        # common/kubernetes.sh
        install_kubectl;

        #Install helm (from https://helm.sh/docs/intro/install/)
        # common/kubernetes.sh
        install_helm;

        #Install docker-compose
        # common/kubernetes.sh
        install_docker_compose;
        
        # Install Terraform
        # common/kubernetes.sh
        install_terraform;
        #wait_cluster;

    elif [[ $option == "docker" ]]; then
        # install docker
        # common/kubernetes.sh
        install_docker;

    elif [[ $option == "create" ]]; then
         # common/cluster.sh
         create_cluster;
         #wait_cluster;

    elif [[ $option == "remove" ]]; then
         # common/cluster.sh
         remove_cluster;

    elif [[ $option == "on" ]]; then
         # common/cluster.sh
         start_cluster;
         #wait_cluster;

    elif [[ $option == "off" ]]; then
         # common/cluster.sh
         stop_cluster;
    else
      echo "($option) is not valid. Valid options are: create or remove."
    fi
  done
fi





