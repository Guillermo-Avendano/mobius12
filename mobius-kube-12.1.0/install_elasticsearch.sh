#!/bin/bash
set -Eeuo pipefail

install_elasticsearch() {
    info_message "Installing elastic search";  
    info_message "Configuring elasticsearch $ELASTICSEARCH_VERSION resources";
  
    cp $kube_dir/elasticsearch/storage/local/templates/$ELASTICSEARCH_STORAGE_FILE $kube_dir/elasticsearch/storage/local/$ELASTICSEARCH_STORAGE_FILE;
	replace_tag_in_file $kube_dir/elasticsearch/storage/local/$ELASTICSEARCH_STORAGE_FILE "<ELASTICSEARCH_VOLUME>" $ELASTICSEARCH_VOLUME;
  
    $KUBE_CLI_EXE apply -f  $kube_dir/elasticsearch/storage/local/$ELASTICSEARCH_STORAGE_FILE --namespace $NAMESPACE

    
    cp $kube_dir/elasticsearch/templates/$ELASTICSEARCH_CONF_FILE $kube_dir/elasticsearch/$ELASTICSEARCH_CONF_FILE;
    replace_tag_in_file $kube_dir/elasticsearch/$ELASTICSEARCH_CONF_FILE "<ELASTICSEARCH_VERSION>" $ELASTICSEARCH_VERSION; 
    replace_tag_in_file $kube_dir/elasticsearch/$ELASTICSEARCH_CONF_FILE "<ELASTICSEARCH_HOST>" $ELASTICSEARCH_HOST; 

    info_message "Updating local Helm repository";

    helm repo add elastic https://helm.elastic.co;
    helm repo update;

    info_message "Deploying elastic search Helm chart";
	
	helm upgrade elasticsearch elastic/elasticsearch -f  $kube_dir/elasticsearch/$ELASTICSEARCH_CONF_FILE -n $NAMESPACE --install
	
	info_message "Clean up resources";
    rm -f $kube_dir/elasticsearch/$ELASTICSEARCH_CONF_FILE
    rm -f $kube_dir/elasticsearch/storage/local/$ELASTICSEARCH_STORAGE_FILE
}

get_elasticsearch_status() {
    $KUBE_CLI_EXE get pods --namespace $NAMESPACE elasticsearch-master-0 -o jsonpath="{.status.phase}" 2>/dev/null
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
        sleep 5;
    done
}

xargsflag="-d"
export $(grep -v '^#' .env | xargs ${xargsflag} '\n')
kube_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
[ -d "$kube_dir" ] || {
    echo "FATAL: no current dir (maybe running in zsh?)"
    exit 1
}

source "$kube_dir/common/common.sh"
source "$kube_dir/common/local_kube.sh"

kube_init;

ELASTICSEARCH_VERSION="${ELASTICSEARCH_VERSION:-7.17.3}";
ELASTICSEARCH_CONF_FILE=elasticsearch.yaml;
ELASTICSEARCH_VOLUME=`eval echo ~/${NAMESPACE}_data/elasticsearch`
ELASTICSEARCH_STORAGE_FILE=elasticsearch-storage.yaml;



install_elasticsearch;
wait_for_elasticsearch_ready;