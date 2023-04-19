#!/bin/bash
#abort in case of cmd failure
set -Eeuo pipefail

xargsflag="-d"
export $(grep -v '^#' .env | xargs $xargsflag '\n')
kube_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
[ -d "$kube_dir" ] || {
    echo "FATAL: no current dir (maybe running in zsh?)"
    exit 1
}



# cluster/local_registry.sh
export KUBE_IMAGES=("mobius-server:$MOBIUS_SERVER_VERSION" "mobius-view:$MOBIUS_VIEW_VERSION" "eventanalytics:$EVENTANALYTICS_VERSION") 
# $HOME/.profile -> DOCKER_PASSWORD encoded base64
export DOCKER_PASS=`echo $DOCKER_PASSWORD | base64 -d` 

source "$kube_dir/cluster/cluster.sh"
export KUBECONFIG=$kube_dir/cluster/cluster-config.yaml

if [[ $# -eq 0 ]]; then
  echo "Parameters:"
  echo "==========="
  echo " - on      : start mobius cluster"
  echo " - off     : stop mobius cluster"
  echo " - imgls   : list images from $KUBE_SOURCE_REGISTRY (var KUBE_IMAGES in env.sh)"
  echo " - imgpull : pull images from $KUBE_SOURCE_REGISTRY (var KUBE_IMAGES in env.sh)"
  echo " - list    : list clusters"
  echo " - create  : create mobius cluster"  
  echo " - remove  : remove mobius cluster"
  echo " - debug   : generate outputs for get/describe of each kubernetes resources"
else
  for option in "$@"; do
    if [[ $option == "on" ]]; then

         if ! exist_cluster; then
            echo "$KUBE_CLUSTER_NAME cluster doesn't exist"
         elif isactive_cluster; then
            echo "$KUBE_CLUSTER_NAME cluster is active"
         else
            # cluster/cluster.sh
            start_cluster;
         fi

    elif [[ $option == "off" ]]; then

         if isactive_cluster; then
            # cluster/cluster.sh
            stop_cluster;
         else
            echo "$KUBE_CLUSTER_NAME cluster is not active"
         fi

    elif [[ $option == "imgls" ]]; then
         # cluster/local_registry.sh
         list_images;

    elif [[ $option == "imgpull" ]]; then
         
         if isactive_cluster; then
            # cluster/local_registry.sh
            push_images_to_local_registry; 
         else
            echo "$KUBE_CLUSTER_NAME cluster is not active"
         fi   

    elif [[ $option == "list" ]]; then
         # cluster/cluster.sh
         list_cluster;

    elif [[ $option == "create" ]]; then
         
         if isactive_cluster; then
            echo "$KUBE_CLUSTER_NAME cluster is active"
         else    
            # cluster/cluster.sh
            create_cluster;
         fi

    elif [[ $option == "remove" ]]; then
         
         if exist_cluster; then
            # cluster/cluster.sh
            remove_cluster;
         else
            echo "$KUBE_CLUSTER_NAME cluster doesn't exist"            
         fi

    elif [[ $option == "debug" ]]; then
         
         if isactive_cluster; then
            # cluster/cluster.sh
            debug_cluster;
         else
            echo "$KUBE_CLUSTER_NAME cluster is not active"            
         fi  

    else    
      echo "($option) is not valid."
    fi
  done
fi