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
  echo " - debug   : generate outputs for get/describe of each kubernetes resources"
else
  for option in "$@"; do
    if [[ $option == "on" ]]; then

         if isactive_cluster; then
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
      echo "($option) is not valid. Valid options are: create or remove."
    fi
  done
fi





