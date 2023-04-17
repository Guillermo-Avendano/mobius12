#!/bin/bash
set -Eeuo pipefail


install_eventanalytics() {
		
	EVENTANALYTICS_VALUES_FILE=eventanalytics.yaml;
    cp $kube_dir/eventanalytics/templates/$EVENTANALYTICS_VALUES_FILE $kube_dir/eventanalytics/$EVENTANALYTICS_VALUES_FILE;
	replace_tag_in_file $kube_dir/eventanalytics/$EVENTANALYTICS_VALUES_FILE "<NAME_LOCALREGISTRY>" $NAME_LOCALREGISTRY;
	replace_tag_in_file $kube_dir/eventanalytics/$EVENTANALYTICS_VALUES_FILE "<PORT_LOCALREGISTRY>" $PORT_LOCALREGISTRY;
	replace_tag_in_file $kube_dir/eventanalytics/$EVENTANALYTICS_VALUES_FILE "<IMAGE_NAME_EVENTANALYTICS>" $IMAGE_NAME_EVENTANALYTICS;
	replace_tag_in_file $kube_dir/eventanalytics/$EVENTANALYTICS_VALUES_FILE "<IMAGE_VERSION_EVENTANALYTICS>" $IMAGE_VERSION_EVENTANALYTICS;
	replace_tag_in_file $kube_dir/eventanalytics/$EVENTANALYTICS_VALUES_FILE "<POSTGRESQL_HOST>" $POSTGRESQL_HOST;
	replace_tag_in_file $kube_dir/eventanalytics/$EVENTANALYTICS_VALUES_FILE "<POSTGRESQL_PORT>" $POSTGRESQL_PORT;
	replace_tag_in_file $kube_dir/eventanalytics/$EVENTANALYTICS_VALUES_FILE "<POSTGRESQL_USERNAME>" $POSTGRESQL_USERNAME;
	replace_tag_in_file $kube_dir/eventanalytics/$EVENTANALYTICS_VALUES_FILE "<POSTGRESQL_PASSWORD>" $POSTGRESQL_PASSWORD;
	replace_tag_in_file $kube_dir/eventanalytics/$EVENTANALYTICS_VALUES_FILE "<POSTGRESQL_DBNAME_EVENTANALYTICS>" $POSTGRESQL_DBNAME_EVENTANALYTICS;
	replace_tag_in_file $kube_dir/eventanalytics/$EVENTANALYTICS_VALUES_FILE "<NAMESPACE>" $NAMESPACE;
	replace_tag_in_file $kube_dir/eventanalytics/$EVENTANALYTICS_VALUES_FILE "<KAFKA_BOOTSTRAP_URL>" $KAFKA_BOOTSTRAP_URL;
	
		
	info_message "Deploy eventanalytics"; 
	if [ -z $IMAGE_EXTRA_ARGS_EVENTANALYTICS]; then
	  helm upgrade eventanalytics -n $NAMESPACE $kube_dir/helm_charts/eventanalytics.tgz -f $kube_dir/eventanalytics/$EVENTANALYTICS_VALUES_FILE --install
  else
    helm upgrade eventanalytics -n $NAMESPACE $kube_dir/helm_charts/eventanalytics.tgz -f $kube_dir/eventanalytics/$EVENTANALYTICS_VALUES_FILE $IMAGE_EXTRA_ARGS_EVENTANALYTICS --install
  fi
	
	
	info_message "Clean up resources";
    rm -f $kube_dir/eventanalytics/$EVENTANALYTICS_VALUES_FILE	

}

get_eventanalytics_status() {
    $KUBE_CLI_EXE get pods --namespace $NAMESPACE eventanalytics -o jsonpath="{.status.phase}" 2>/dev/null
}

wait_for_eventanalytics_ready() {
    info_message "Waiting for eventanalytics to be ready";
    COUNTER=0
	output=`kubectl get pods -n $NAMESPACE -o go-template --template '{{range .items}}{{if eq (.status.phase) ("Running")}}{{.metadata.name}}{{"\n"}}{{end}}{{end}}'`
    until [[ "$output" == *eventanalytics* ]]
    do
        info_progress "...";
		let COUNTER=COUNTER+5
		if [[ "$COUNTER" -gt 300 ]]; then
		  echo "FATAL: Failed to install eventanalytics. Please check logs and configuration"
          exit 1    
		fi
        sleep 5;
		output=`kubectl get pods -n $NAMESPACE -o go-template --template '{{range .items}}{{if eq (.status.phase) ("Running")}}{{.metadata.name}}{{"\n"}}{{end}}{{end}}'`
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


install_eventanalytics;
wait_for_eventanalytics_ready;
