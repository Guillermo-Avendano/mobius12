#!/bin/bash

source "$kube_dir/common/common.sh"

install_postgresql() {
    info_message "Creating database namespace and storage";
    
    if ! kubectl get namespace "$DATABASE_NAMESPACE" >/dev/null 2>&1; then
        kubectl create namespace "$DATABASE_NAMESPACE";
    fi 
	
	#POSTGRES_VOLUME=`eval echo ~/${NAMESPACE}_data/postgres`
	POSTGRES_STORAGE_FILE=postgres-storage.yaml

    cp $kube_dir/database/storage/local/templates/$POSTGRES_STORAGE_FILE $kube_dir/database/storage/local/$POSTGRES_STORAGE_FILE;

    POSTGRES_CONF_FILE=$kube_dir/database/$POSTGRES_VALUES_TEMPLATE;
    cp $kube_dir/database/templates/$POSTGRES_VALUES_TEMPLATE $POSTGRES_CONF_FILE;

    POSTGRESQL_VERSION="${POSTGRESQL_VERSION:-14.5.0}";

    info_message "Configuring Postgresql $POSTGRESQL_VERSION resources";

    replace_tag_in_file $POSTGRES_CONF_FILE "<image_tag>" $POSTGRESQL_VERSION;
    replace_tag_in_file $POSTGRES_CONF_FILE "<database_user>" $POSTGRESQL_USERNAME;
    replace_tag_in_file $POSTGRES_CONF_FILE "<database_password>" $POSTGRESQL_PASSWORD;
    replace_tag_in_file $POSTGRES_CONF_FILE "<database_name_mobiusview>" $POSTGRESQL_DBNAME_MOBIUSVIEW;
    replace_tag_in_file $POSTGRES_CONF_FILE "<database_name_mobius>" $POSTGRESQL_DBNAME_MOBIUS;    
	replace_tag_in_file $POSTGRES_CONF_FILE "<database_name_eventanalytics>" $POSTGRESQL_DBNAME_EVENTANALYTICS;
	replace_tag_in_file $POSTGRES_CONF_FILE "<postgres_port>" $POSTGRESQL_PORT;

    kubectl apply -f $kube_dir/database/storage/local/$POSTGRES_STORAGE_FILE --namespace $DATABASE_NAMESPACE;
    
    info_message "Updating local Helm repository";

    helm repo add bitnami https://charts.bitnami.com/bitnami;
    helm repo update;

    info_message "Deploying postgresql Helm chart";

    helm upgrade -f $POSTGRES_CONF_FILE postgresql bitnami/postgresql --namespace $DATABASE_NAMESPACE --version 11.8.2 --install;
}

uninstall_postgresql() {
    helm uninstall postgresql --namespace $DATABASE_NAMESPACE;
    kubectl delete -f $kube_dir/database/storage/local/$POSTGRES_STORAGE_FILE --namespace $DATABASE_NAMESPACE;
}

get_postgres_status() {
    kubectlget pods --namespace $DATABASE_NAMESPACE postgresql-0 -o jsonpath="{.status.phase}" 2>/dev/null
}

configure_port_forwarding() {
    kubectlport-forward --namespace $DATABASE_NAMESPACE postgresql-0 5432:5432 &
}

wait_for_postgres_ready() {
    until [ "$(get_postgres_status)" == "Running" ]
    do
        info_progress "...";
        sleep 3;
    done
}

#configure_postgres() {
#    pushd $kube_dir/pgadmin
#    install_pgadmin;
#    popd
#}

get_postgres_service() {
    echo $POSTGRESQL_HOST
}

get_postgres_port() {
    echo $POSTGRESQL_PORT
}
