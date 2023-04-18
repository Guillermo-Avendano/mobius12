#!/bin/bash
set -Eeuo pipefail


install_pgadmin() {
	
	PGADMIN_STORAGE_FILE=pgadmin_storage.yaml;
    cp $kube_dir/pgadmin/storage/local/templates/$PGADMIN_STORAGE_FILE $kube_dir/pgadmin/storage/local/$PGADMIN_STORAGE_FILE;
	
	replace_tag_in_file $kube_dir/pgadmin/storage/local/$PGADMIN_STORAGE_FILE "<PGADMIN_PV_VOLUME>" $PGADMIN_PV_VOLUME;
    replace_tag_in_file $kube_dir/pgadmin/storage/local/$PGADMIN_STORAGE_FILE "<PGADMIN_PVC>"       $PGADMIN_PV_VOLUME;
	
	PGADMIN_VALUES_FILE=pgadmin-values.yaml;
    cp $kube_dir/pgadmin/templates/$PGADMIN_VALUES_FILE $kube_dir/pgadmin/$PGADMIN_VALUES_FILE;

	replace_tag_in_file $kube_dir/pgadmin/$PGADMIN_VALUES_FILE "<NAMESPACE>" $NAMESPACE;
	replace_tag_in_file $kube_dir/pgadmin/$PGADMIN_VALUES_FILE "<PGADMIN_HOST>" $PGADMIN_HOST;
	replace_tag_in_file $kube_dir/pgadmin/$PGADMIN_VALUES_FILE "<PGADMIN_MAIL>" $PGADMIN_MAIL;
	replace_tag_in_file $kube_dir/pgadmin/$PGADMIN_VALUES_FILE "<PGADMIN_PASS>" $PGADMIN_PASS;
	  
    info_message "Creating pgadmin storage";    
    $KUBE_CLI_EXE apply -f $kube_dir/pgadmin/storage/local/pgadmin_storage.yaml --namespace $NAMESPACE;
	
	info_message "Deploy pgadmin"; 
    helm upgrade pgadmin -n $NAMESPACE $kube_dir/helm_charts/pgadmin -f $kube_dir/pgadmin/pgadmin-values.yaml --install

	info_message "Clean up resources";
    rm -f $kube_dir/pgadmin/storage/local/$PGADMIN_STORAGE_FILE
    rm -f $kube_dir/pgadmin/$PGADMIN_VALUES_FILE	

}


wait_for_pgadmin_ready() {
    info_message "Waiting for pgadmin to be ready";
    COUNTER=0
	output=`kubectl get pods -n $NAMESPACE -o go-template --template '{{range .items}}{{if eq (.status.phase) ("Running")}}{{.metadata.name}}{{"\n"}}{{end}}{{end}}'`
    until [[ "$output" == *pgadmin* ]]
    do
        info_progress "...";
		let COUNTER=COUNTER+5
		if [[ "$COUNTER" -gt 300 ]]; then
		  echo "FATAL: Failed to install pgadmin. Please check logs and configuration"
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

PGADMIN_PV_VOLUME=`eval echo ~/${NAMESPACE}_data/pgadmin/pv`


install_pgadmin;
wait_for_pgadmin_ready;
