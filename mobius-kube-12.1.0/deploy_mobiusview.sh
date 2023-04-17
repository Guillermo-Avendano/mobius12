#!/bin/bash
set -Eeuo pipefail


install_mobiusview() {
	
	MOBIUSVIEW_STORAGE_FILE=mobiusview_storage.yaml;
    cp $kube_dir/mobiusview/storage/local/templates/$MOBIUSVIEW_STORAGE_FILE $kube_dir/mobiusview/storage/local/$MOBIUSVIEW_STORAGE_FILE;
	
	replace_tag_in_file $kube_dir/mobiusview/storage/local/$MOBIUSVIEW_STORAGE_FILE "<MOBIUSVIEW_DIAGNOSTIC_VOLUME>" $MOBIUSVIEW_DIAGNOSTIC_VOLUME;
	replace_tag_in_file $kube_dir/mobiusview/storage/local/$MOBIUSVIEW_STORAGE_FILE "<MOBIUSVIEW_PV_VOLUME>" $MOBIUSVIEW_PV_VOLUME;
	
	MOBIUSVIEW_VALUES_FILE=mobiusview.yaml;
    cp $kube_dir/mobiusview/templates/$MOBIUSVIEW_VALUES_FILE $kube_dir/mobiusview/$MOBIUSVIEW_VALUES_FILE;
	replace_tag_in_file $kube_dir/mobiusview/$MOBIUSVIEW_VALUES_FILE "<NAME_LOCALREGISTRY>" $NAME_LOCALREGISTRY;
	replace_tag_in_file $kube_dir/mobiusview/$MOBIUSVIEW_VALUES_FILE "<PORT_LOCALREGISTRY>" $PORT_LOCALREGISTRY;
	replace_tag_in_file $kube_dir/mobiusview/$MOBIUSVIEW_VALUES_FILE "<IMAGE_NAME_MOBIUSVIEW>" $IMAGE_NAME_MOBIUSVIEW;
	replace_tag_in_file $kube_dir/mobiusview/$MOBIUSVIEW_VALUES_FILE "<IMAGE_VERSION_MOBIUSVIEW>" $IMAGE_VERSION_MOBIUSVIEW;
	replace_tag_in_file $kube_dir/mobiusview/$MOBIUSVIEW_VALUES_FILE "<POSTGRESQL_USERNAME>" $POSTGRESQL_USERNAME;
	replace_tag_in_file $kube_dir/mobiusview/$MOBIUSVIEW_VALUES_FILE "<POSTGRESQL_PASSWORD>" $POSTGRESQL_PASSWORD;
	replace_tag_in_file $kube_dir/mobiusview/$MOBIUSVIEW_VALUES_FILE "<POSTGRESQL_HOST>" $POSTGRESQL_HOST;
	replace_tag_in_file $kube_dir/mobiusview/$MOBIUSVIEW_VALUES_FILE "<POSTGRESQL_PORT>" $POSTGRESQL_PORT;
	replace_tag_in_file $kube_dir/mobiusview/$MOBIUSVIEW_VALUES_FILE "<POSTGRESQL_DBNAME_MOBIUSVIEW>" $POSTGRESQL_DBNAME_MOBIUSVIEW;
	replace_tag_in_file $kube_dir/mobiusview/$MOBIUSVIEW_VALUES_FILE "<NAMESPACE>" $NAMESPACE;
	replace_tag_in_file $kube_dir/mobiusview/$MOBIUSVIEW_VALUES_FILE "<KAFKA_BOOTSTRAP_URL>" $KAFKA_BOOTSTRAP_URL;

	MOBIUSVIEW_LICENSE_FILE=mobius-license.yaml;
    cp $kube_dir/mobiusview/secrets/templates/$MOBIUSVIEW_LICENSE_FILE $kube_dir/mobiusview/secrets/$MOBIUSVIEW_LICENSE_FILE;
	LICENSE_KEY=`echo $LICENSE_KEY | base64 -w 0`
    replace_tag_in_file $kube_dir/mobiusview/secrets/$MOBIUSVIEW_LICENSE_FILE "<MOBIUS_LICENSE>" $LICENSE_KEY;
	
	
	
	info_message "Applying secrets";
	  if [ -n "$(ls  $kube_dir/mobiusview/secrets/*.yaml 2>/dev/null)" ]; then   
	    $KUBE_CLI_EXE apply -f $kube_dir/mobiusview/secrets/$MOBIUSVIEW_LICENSE_FILE --namespace $NAMESPACE
	  fi
	  
    info_message "Creating mobiusview storage";    
    $KUBE_CLI_EXE apply -f $kube_dir/mobiusview/storage/local/mobiusview_storage.yaml --namespace $NAMESPACE;
	
	info_message "Deploy mobiusview"; 
	if [ -z $IMAGE_EXTRA_ARGS_MOBIUSVIEW]; then
	  helm upgrade mobiusview -n $NAMESPACE $kube_dir/helm_charts/mobiusview.tgz -f $kube_dir/mobiusview/mobiusview.yaml --install
  else
    helm upgrade mobiusview -n $NAMESPACE $kube_dir/helm_charts/mobiusview.tgz -f $kube_dir/mobiusview/mobiusview.yaml $IMAGE_EXTRA_ARGS_MOBIUSVIEW --install
  fi
	
	
	info_message "Clean up resources";
    rm -f $kube_dir/mobiusview/storage/local/$MOBIUSVIEW_STORAGE_FILE
    rm -f $kube_dir/mobiusview/$MOBIUSVIEW_VALUES_FILE
    rm -f $kube_dir/mobiusview/secrets/$MOBIUSVIEW_LICENSE_FILE

}


wait_for_mobiusview_ready() {
    info_message "Waiting for mobiusview to be ready";
    COUNTER=0
	output=`kubectl get pods -n $NAMESPACE -o go-template --template '{{range .items}}{{if eq (.status.phase) ("Running")}}{{.metadata.name}}{{"\n"}}{{end}}{{end}}'`
    until [[ "$output" == *mobiusview* ]]
    do
        info_progress "...";
		let COUNTER=COUNTER+5
		if [[ "$COUNTER" -gt 300 ]]; then
		  echo "FATAL: Failed to install mobiusview. Please check logs and configuration"
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

MOBIUSVIEW_PV_VOLUME=`eval echo ~/${NAMESPACE}_data/mobiusview/pv`
MOBIUSVIEW_DIAGNOSTIC_VOLUME=`eval echo ~/${NAMESPACE}_data/mobiusview/log`


install_mobiusview;
wait_for_mobiusview_ready;
