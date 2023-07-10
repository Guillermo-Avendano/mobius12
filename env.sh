#!/bin/bash

kube_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
[ -d "$kube_dir" ] || {
    echo "FATAL: no current dir (maybe running in zsh?)"
    exit 1
}

################################################################################
# KUBERNETES CONFIG
################################################################################
KUBE_CLUSTER_NAME="mobius12"                               # cluster/cluster.sh

NAMESPACE=mobius12
NAMESPACE_SHARED=shared

PRODUCT="Mobius 12.2"

export KUBECONFIG=$kube_dir/cluster/cluster-config.yaml    # cluster/cluster.sh

DOCKER_USER=$DOCKER_USERNAME                       # cluster/local_registry.sh  $HOME/.profile
DOCKER_PASS=$DOCKER_PASSWORD                       # cluster/local_registry.sh  $HOME/.profile

# Storage Class
KUBE_CLUSTER_STORAGE=$kube_dir/pv-cluster           # cluster/cluster.sh

KUBE_SOURCE_REGISTRY="registry.rocketsoftware.com"  # cluster/local_registry.sh 
KUBE_LOCALREGISTRY_NAME="mobius.localhost"          # cluster/local_registry.sh
KUBE_LOCALREGISTRY_HOST="localhost"                 # cluster/local_registry.sh 
KUBE_LOCALREGISTRY_PORT="5000"                      # cluster/local_registry.sh 
NGINX_EXTERNAL_TLS_PORT=443
KUBE_IMAGE_PULL="YES"                               # cluster/cluster.sh
KUBE_PORTAINER="NO"                                 # cluster/cluster.sh
KUBE_PGADMIN="YES"                                  # database/database.sh
KUBE_GRAFANA="YES"                                  # database/database.sh

export KUBE_NS_LIST=( "$NAMESPACE" "$NAMESPACE_SHARED" )

################################################################################
# MOBIUS IMAGES
################################################################################
IMAGE_NAME_MOBIUS=mobius-server
IMAGE_VERSION_MOBIUS=12.2.0
IMAGE_EXTRA_ARGS_MOBIUS=
IMAGE_NAME_MOBIUSVIEW=mobius-view
IMAGE_VERSION_MOBIUSVIEW=12.2.0
IMAGE_EXTRA_ARGS_MOBIUSVIEW=
IMAGE_NAME_EVENTANALYTICS=eventanalytics
IMAGE_VERSION_EVENTANALYTICS=1.3.8
MOBIUS_VIEW_URL="mobius12.local.net"

export KUBE_IMAGES=("mobius-server:$IMAGE_VERSION_MOBIUS" "mobius-view:$IMAGE_VERSION_MOBIUSVIEW" "eventanalytics:$IMAGE_VERSION_EVENTANALYTICS") # cluster/local_registry.sh

################################################################################
# DATABASES
################################################################################
EXTERNAL_DATABASE=false
DATABASE_PROVIDER=postgresql
POSTGRESQL_VERSION=14.5.0
POSTGRESQL_USERNAME=mobius
POSTGRESQL_PASSWORD=postgres
POSTGRESQL_DBNAME_MOBIUSVIEW=mobiusview
POSTGRESQL_DBNAME_MOBIUS=mobiusserver
POSTGRESQL_DBNAME_EVENTANALYTICS=eventanalytics
POSTGRESQL_HOST=postgresql.$NAMESPACE_SHARED
POSTGRESQL_PORT=5432
export POSTGRES_VALUES_TEMPLATE=postgres-mobius.yaml

################################################################################
# ELASTICSEARCH
################################################################################
ELASTICSEARCH_ENABLED=true
ELASTICSEARCH_VERSION=7.17.3
ELASTICSEARCH_URL=elastic.local.net
ELASTICSEARCH_HOST=elasticsearch-master.$NAMESPACE_SHARED
ELASTICSEARCH_PORT=9200

################################################################################
# KAFKA
################################################################################
KAFKA_ENABLED=true
KAFKA_VERSION=3.3.1-debian-11-r3
KAFKA_BOOTSTRAP_URL=kafka.$NAMESPACE_SHARED:9092


################################################################################
# TERRAFORM
################################################################################


export TF_VAR_NAMESPACE=$NAMESPACE                  # shared/variables.tf 
                                                    # mobius/variables.tf 
                                                    # mobius/install.sh
                                                    # mobius/main.tf 
                                                    # mobius/remove.sh 
export TF_VAR_NAMESPACE_SHARED=$NAMESPACE_SHARED    # shared/install.sh
                                                    # shared/remove.sh 

export TF_VAR_KUBE_LOCALREGISTRY_HOST=$KUBE_LOCALREGISTRY_HOST          # cluster/local_registry.sh 
export TF_VAR_KUBE_LOCALREGISTRY_PORT=$KUBE_LOCALREGISTRY_PORT          # cluster/local_registry.sh

export TF_VAR_IMAGE_VERSION_MOBIUS=$IMAGE_VERSION_MOBIUS
export TF_VAR_IMAGE_VERSION_MOBIUSVIEW=$IMAGE_VERSION_MOBIUSVIEW
export TF_VAR_IMAGE_VERSION_EVENTANALYTICS=$IMAGE_VERSION_EVENTANALYTICS

export TF_VAR_IMAGE_NAME_MOBIUS=$IMAGE_NAME_MOBIUS
export TF_VAR_IMAGE_NAME_MOBIUSVIEW=$IMAGE_NAME_MOBIUSVIEW
export TF_VAR_IMAGE_NAME_EVENTANALYTICS=$IMAGE_NAME_EVENTANALYTICS

export TF_VAR_POSTGRESQL_HOST=$POSTGRESQL_HOST
export TF_VAR_POSTGRESQL_PORT=$POSTGRESQL_PORT
export TF_VAR_POSTGRESQL_USERNAME=$POSTGRESQL_USERNAME
export TF_VAR_POSTGRESQL_PASSWORD=$POSTGRESQL_PASSWORD
export TF_VAR_POSTGRESQL_DBNAME_MOBIUSVIEW=$POSTGRESQL_DBNAME_MOBIUSVIEW
export TF_VAR_POSTGRESQL_DBNAME_MOBIUS=$POSTGRESQL_DBNAME_MOBIUS
export TF_VAR_POSTGRESQL_DBNAME_EVENTANALYTICS=$POSTGRESQL_DBNAME_EVENTANALYTICS


#http://mobius12.local.net/mobius/admin
export TF_VAR_MOBIUS_VIEW_URL=$MOBIUS_VIEW_URL  # mobius/main.tf used in ingress

export TF_VAR_MOBIUS_LICENSE=$MOBIUS_LICENSE

TF_VAR_ENABLEINDEX=$ELASTICSEARCH_ENABLED
TF_VAR_MOBIUS_FTS_HOST=$ELASTICSEARCH_HOST
TF_VAR_MOBIUS_FTS_PORT=$ELASTICSEARCH_PORT
TF_VAR_MOBIUS_FTS_INDEX_NAME="mobius12"

TF_VAR_KAFKA_BOOTSTRAP_URL=$KAFKA_BOOTSTRAP_URL

# mobius service/port for comunication mobius with mobiusviews
TF_VAR_MOBIUS_HOST="mobius12"
TF_VAR_MOBIUS_HOST="8080"

########################################################################
# In processing
# NAMESPACE=test
# declare -A pv
# pv['MOBIUS_PV_VOLUME']=~/${NAMESPACE}_data/mobius/pv
# pv['MOBIUS_FTS_VOLUME']=~/${NAMESPACE}_data/mobius/fts
# pv['MOBIUS_DIAGNOSTIC_VOLUME']=~/${NAMESPACE}_data/mobius/log

# pv['MOBIUSVIEW_PV_VOLUME']=~/${NAMESPACE}_data/mobiusview/pv
# pv['MOBIUSVIEW_DIAGNOSTIC_VOLUME']=~/${NAMESPACE}_data/mobiusview/log

# pv['COMMON_VOLUME']=~/${NAMESPACE}_data/common
# pv['POSTGRES_VOLUME']=~/${NAMESPACE}_data/postgres
# pv['KAFKA_VOLUME']=~/${NAMESPACE}_data/kafka
# pv['ELASTICSEARCH_VOLUME']=~/${NAMESPACE}_data/elasticsearch
# pv['PGADMIN_VOLUME']=~/${NAMESPACE}_data/pgadmin

# VOLUME_MAPPING=""
# for local_pv in ${!pv[@]}; do
    #if [ ! -d ${pv[${local_pv}]} ]; then

        #mkdir -p ${pv[${local_pv}]};
        #chmod -R 777 ${pv[${local_pv}]};
    #fi 
   # VOL_MAP=`eval echo ${pv[${local_pv}]}`
   # VOLUME_MAPPING+="--volume $VOL_MAP:$VOL_MAP "
    #echo Creating: $local_pv ${pv[${local_pv}]}
#done

# KUBE_CLUSTER_EXTRA_ARGS="$VOLUME_MAPPING --wait";
