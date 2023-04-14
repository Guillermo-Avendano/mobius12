#!/bin/bash

kube_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
[ -d "$kube_dir" ] || {
    echo "FATAL: no current dir (maybe running in zsh?)"
    exit 1
}

KUBE_CLUSTER_NAME="mobius"                         # cluster/cluster.sh

export KUBECONFIG=$kube_dir/kube/config            # cluster/cluster.sh

DOCKER_USER="gavendano@rs.com"                     # cluster/local_registry.sh  
DOCKER_PASS=`echo $DOCKER_PASSWORD | base64 -d`    # $HOME/.profile -> DOCKER_PASSWORD encoded base64

KUBE_SOURCE_REGISTRY="registry.rocketsoftware.com"  # cluster/local_registry.sh 
KUBE_LOCALREGISTRY_NAME="registry.localhost"        # cluster/local_registry.sh
KUBE_LOCALREGISTRY_HOST="localhost"                 # cluster/local_registry.sh 
KUBE_LOCALREGISTRY_PORT="5000"                      # cluster/local_registry.sh 

export KUBE_IMAGES=("mobius-server:12.1.0004" "mobius-view:12.1.1" "eventanalytics:1.3.8") # cluster/local_registry.sh

MOBIUS_SERVER_VERSION="12.1.0004"                   # mobius/main.tf
MOBIUS_VIEW_VERSION="12.1.1"                        # mobius/main.tf  
EVENTANALYTICS_VERSION="1.3.8"                      # mobius/main.tf

export TF_VAR_NAMESPACE="mobius-prod"               # shared/variables.tf 
                                                    # mobius/variables.tf 
                                                    # mobius/install.sh
                                                    # mobius/main.tf 
                                                    # mobius/remove.sh 
export TF_VAR_NAMESPACE_SHARED="shared"             # shared/variables.tf 
                                                    # shared/main.tf
                                                    # shared/install.sh
                                                    # shared/remove.sh 

export TF_VAR_MOBIUS_VIEW_URL="mobius12.local.net"    # mobius/main.tf used in ingress                                                     