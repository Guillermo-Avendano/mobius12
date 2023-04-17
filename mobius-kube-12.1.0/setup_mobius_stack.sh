#!/bin/bash
#abort in case of cmd failure
set -Eeuo pipefail

xargsflag="-d"
export $(grep -v '^#' .env | xargs ${xargsflag} '\n')
kube_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
[ -d "$kube_dir" ] || {
    echo "FATAL: no current dir (maybe running in zsh?)"
    exit 1
}

#execute dos2unix
find . -name "*.yaml" -exec dos2unix {} \;
find . -name "*.sh" -exec dos2unix {} \;
dos2unix .env

source "$kube_dir/common/kubernetes.sh"

#set up cluster with local registry and push images
$kube_dir/create_k3d_cluster.sh
#create namespace
create_kubernetes_namespace $NAMESPACE;
export DATABASE_NAMESPACE=$NAMESPACE;
export external_database=$EXTERNAL_DATABASE;

#install db
$kube_dir/install_database.sh

#install elasticsearch
if [ "$ELASTICSEARCH_ENABLED" == "true" ]; then
   $kube_dir/install_elasticsearch.sh
fi

#install kafka
if [ "$KAFKA_ENABLED" == "true" ]; then
   $kube_dir/install_kafka.sh
fi

#deploy eventanalytics
$kube_dir/deploy_eventanalytics.sh

#deploy mobius
$kube_dir/deploy_mobius.sh

#deploy mobius
$kube_dir/deploy_mobiusview.sh

#deploy nginx
$kube_dir/install_nginx.sh
