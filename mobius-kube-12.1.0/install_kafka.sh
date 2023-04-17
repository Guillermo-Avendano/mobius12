#!/bin/bash
set -Eeuo pipefail

install_kafka() {
    
      
    info_message "Configuring kafka $KAFKA_VERSION resources";
				
    cp $kube_dir/kafka/storage/local/templates/$KAFKA_STORAGE_FILE $kube_dir/kafka/storage/local/$KAFKA_STORAGE_FILE;
	replace_tag_in_file $kube_dir/kafka/storage/local/$KAFKA_STORAGE_FILE "<KAFKA_VOLUME>" $KAFKA_VOLUME;
   
    cp $kube_dir/kafka/templates/$KAFKA_CONF_FILE $kube_dir/kafka/$KAFKA_CONF_FILE;
    replace_tag_in_file $kube_dir/kafka/$KAFKA_CONF_FILE "<KAFKA_VERSION>" $KAFKA_VERSION; 
	
	$KUBE_CLI_EXE apply -f  $kube_dir/kafka/storage/local/$KAFKA_STORAGE_FILE --namespace $NAMESPACE
	
	$KUBE_CLI_EXE apply -f  $kube_dir/kafka/$KAFKA_CONF_FILE --namespace $NAMESPACE 
	
	#info_message "Clean up resources";
    rm -f $kube_dir/kafka/$KAFKA_CONF_FILE
    rm -f $kube_dir/kafka/storage/local/$KAFKA_STORAGE_FILE	
}

get_kafka_status() {
    $KUBE_CLI_EXE get pods --namespace $NAMESPACE kafka-0 -o jsonpath="{.status.phase}" 2>/dev/null
}

uninstall_kafka() {
    cp $kube_dir/kafka/templates/$KAFKA_CONF_FILE $kube_dir/kafka/$KAFKA_CONF_FILE;
    replace_tag_in_file $kube_dir/kafka/$KAFKA_CONF_FILE "<KAFKA_VERSION>" $KAFKA_VERSION; 
    info_message "Deleting $KAFKA_VERSION resources";
	$KUBE_CLI_EXE delete -f  $kube_dir/kafka/$KAFKA_CONF_FILE --namespace $NAMESPACE  
	rm -f $kube_dir/kafka/$KAFKA_CONF_FILE
}

wait_for_kafka_ready() {
    info_message "Waiting for kafka to be ready";
    COUNTER=0
    until [ "$(get_kafka_status)" == "Running" ]
    do
        info_progress "...";
		let COUNTER=COUNTER+5
		if [[ "$COUNTER" -gt 600 ]]; then
		  echo "FATAL: Failed to install kafka. Please check logs and configuration"
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

KAFKA_VOLUME=`eval echo ~/${NAMESPACE}_data/kafka`
KAFKA_CONF_FILE=kafka-statefulset.yaml;
KAFKA_VERSION="${KAFKA_VERSION:-3.3.1-debian-11-r3}";
KAFKA_STORAGE_FILE=kafka-storage.yaml;

install_kafka;
wait_for_kafka_ready;