#!/bin/bash
set -Eeuo pipefail

source "../env.sh"
source "../common/common.sh"

install_elasticsearch() {
    info_message "Installing elastic search";  
    info_message "Configuring elasticsearch $ELASTICSEARCH_VERSION resources";
  
    cp ../elasticsearch/storage/local/templates/$ELASTICSEARCH_STORAGE_FILE ../elasticsearch/storage/local/$ELASTICSEARCH_STORAGE_FILE;
	replace_tag_in_file ../elasticsearch/storage/local/$ELASTICSEARCH_STORAGE_FILE "<ELASTICSEARCH_VOLUME>" $ELASTICSEARCH_VOLUME;
  
    if ! kubectl get namespace "$NAMESPACE" >/dev/null 2>&1; then
        kubectl create namespace "$NAMESPACE"
    fi 

    kubectl apply -f  ../elasticsearch/storage/local/$ELASTICSEARCH_STORAGE_FILE --namespace $NAMESPACE

    
    cp ../elasticsearch/templates/$ELASTICSEARCH_CONF_FILE ../elasticsearch/$ELASTICSEARCH_CONF_FILE;
    replace_tag_in_file ../elasticsearch/$ELASTICSEARCH_CONF_FILE "<ELASTICSEARCH_VERSION>" $ELASTICSEARCH_VERSION; 
    replace_tag_in_file ../elasticsearch/$ELASTICSEARCH_CONF_FILE "<ELASTICSEARCH_URL>" $ELASTICSEARCH_URL; 

    info_message "Updating local Helm repository";

    helm repo add elastic https://helm.elastic.co;
    helm repo update;

    info_message "Deploying elastic search Helm chart";
	
	helm upgrade elasticsearch elastic/elasticsearch -f  ../elasticsearch/$ELASTICSEARCH_CONF_FILE -n $NAMESPACE --install
	
	info_message "Clean up resources";
    rm -f ../elasticsearch/$ELASTICSEARCH_CONF_FILE
    rm -f ../elasticsearch/storage/local/$ELASTICSEARCH_STORAGE_FILE
}

uninstall_elasticsearch() {
    helm uninstall elasticsearch --namespace $NAMESPACE;
}

get_elasticsearch_status() {
    kubectl get pods --namespace $NAMESPACE elasticsearch-master-0 -o jsonpath="{.status.phase}" 2>/dev/null
}

wait_for_elasticsearch_ready() {
    info_message "Waiting for elasticsearch to be ready";
    COUNTER=0
    until [ "$(get_elasticsearch_status)" == "Running" ]
    do
        info_progress "...";
		let COUNTER=COUNTER+5
		if [[ "$COUNTER" -gt 600 ]]; then
		  echo "FATAL: Failed to install elasticsearch. Please check logs and configuration"
          exit 1    
		fi
        sleep 3;
    done
    info_message "elasticsearch started successfully";
}





#ELASTICSEARCH_VERSION="${ELASTICSEARCH_VERSION:-7.17.3}";
#ELASTICSEARCH_CONF_FILE=elasticsearch.yaml;
#ELASTICSEARCH_VOLUME=`eval echo ~/${NAMESPACE}_data/elasticsearch`
#ELASTICSEARCH_STORAGE_FILE=elasticsearch-storage.yaml;

#install_elasticsearch;
#wait_for_elasticsearch_ready;