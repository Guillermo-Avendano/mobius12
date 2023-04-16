#!/bin/bash

kube_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
[ -d "$kube_dir" ] || {
    echo "FATAL: no current dir (maybe running in zsh?)"
    exit 1
}

KUBE_CLUSTER_NAME="mobius"                                 # cluster/cluster.sh
export KUBECONFIG=$kube_dir/cluster/cluster-config.yaml    # cluster/cluster.sh

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
#http://mobius12.local.net/mobius/admin
export TF_VAR_MOBIUS_VIEW_URL="mobius12.local.net"  # mobius/main.tf used in ingress

export TF_VAR_MOBIUS_LICENSE="01MOBIUS52464A464C4BC95859518381908FAEA4434F46515E53539681955B454D6240534556564351471D454D12405303565672514759454D1640530556560B51470E454D6040537C56560D514715454D1040536556560351470A454D0540531356560951472A454D2A40531556561D5642BB544F4A095454A4A7A744454B0C4A4FB2A2A0365456594348D9B486"

# http://pgadmin.local.net/pgadmin4
export TF_VAR_PGADMIN_URL="pgadmin.local.net"       # shared/variables.tf
                                                    # shared/main.tf
# http://elastic.local.net
export TF_VAR_ELASTIC_URL="elastic.local.net"       # shared/variables.tf
                                                    # shared/main.tf
                                                                                                        
                                                    