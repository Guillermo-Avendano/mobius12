#!/bin/bash

source "./env.sh"

source "$kube_dir/cluster/cluster.sh"


if [[ $# -eq 0 ]]; then
  echo "Parameters:"
  echo "==========="
  echo " - on      : start mobius cluster"
  echo " - off     : stop mobius cluster"
  echo " - create  : create mobius cluster"
  echo " - remove  : remove mobius cluster"
else
  for option in "$@"; do
    if [[ $option == "create" ]]; then
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





