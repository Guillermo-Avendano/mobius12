#!/bin/bash

source "./env.sh"
source "$kube_dir/cluster/cluster.sh"

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
else
  for option in "$@"; do
    if [[ $option == "on" ]]; then
         # cluster/cluster.sh
         start_cluster;

    elif [[ $option == "off" ]]; then
         # cluster/cluster.sh
         stop_cluster;

    elif [[ $option == "imgls" ]]; then
         # cluster/local_registry.sh
         list_images;

    elif [[ $option == "imgpull" ]]; then
         # cluster/local_registry.sh
         if isactive_cluster; then
            push_images_to_local_registry; 
         else
            echo "$KUBE_CLUSTER_NAME cluster is not active"
         fi   

    elif [[ $option == "list" ]]; then
         # cluster/cluster.sh
         list_cluster;

    elif [[ $option == "create" ]]; then
         # cluster/cluster.sh
         create_cluster;

    elif [[ $option == "remove" ]]; then
         # cluster/cluster.sh
         if exist_cluster; then
            remove_cluster;
         else
            echo "$KUBE_CLUSTER_NAME cluster doesn't exist"            
         fi   
    else    
      echo "($option) is not valid. Valid options are: create or remove."
    fi
  done
fi





