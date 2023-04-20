#!/bin/bash
#abort in case of cmd failure
set -Eeuo pipefail

source ../env.sh
source ../database/database.sh
source ../elasticsearch/elasticsearch.sh
source ../kafka/kafka.sh

export NAMESPACE=$TF_VAR_NAMESPACE_SHARED;

#install database
highlight_message "Deploying database services"

install_database;

info_progress_header "Waiting for database services to be ready ...";
wait_for_database_ready;
info_message "The database services are ready now.";

#install elasticsearch
if [ "$ELASTICSEARCH_ENABLED" == "true" ]; then
   ELASTICSEARCH_VERSION="${ELASTICSEARCH_VERSION:-7.17.3}";
   ELASTICSEARCH_CONF_FILE=elasticsearch.yaml;
   ELASTICSEARCH_VOLUME=`eval echo ~/${NAMESPACE}_data/elasticsearch`
   ELASTICSEARCH_STORAGE_FILE=elasticsearch-storage.yaml;

   install_elasticsearch;
   wait_for_elasticsearch_ready; 
fi

#install kafka
if [ "$KAFKA_ENABLED" == "true" ]; then
   KAFKA_VOLUME=`eval echo ~/${NAMESPACE}_data/kafka`
   KAFKA_CONF_FILE=kafka-statefulset.yaml;
   KAFKA_VERSION="${KAFKA_VERSION:-3.3.1-debian-11-r3}";
   KAFKA_STORAGE_FILE=kafka-storage.yaml;

   install_kafka;
   wait_for_kafka_ready;
fi
