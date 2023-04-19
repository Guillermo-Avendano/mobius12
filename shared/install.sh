#!/bin/bash
#abort in case of cmd failure
set -Eeuo pipefail

source ../env.sh

export DATABASE_NAMESPACE=$TF_VAR_NAMESPACE_SHARED;
export external_database=$EXTERNAL_DATABASE;

#install db
./install_database.sh

#install elasticsearch
if [ "$ELASTICSEARCH_ENABLED" == "true" ]; then
   ./install_elasticsearch.sh
fi

#install kafka
if [ "$KAFKA_ENABLED" == "true" ]; then
   ./install_kafka.sh
fi
