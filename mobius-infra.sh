#!/bin/bash

show_hints() {
    local blue=`tput setaf 4`
    local green=`tput setaf 2`
    local red=`tput setaf 1`
    local reset=`tput sgr0`
    local kubeconfig="zenith-kubeconfig";
    local zenith_url="$ZENITH_DOMAIN:$ZENITH_PORT";

    if [ "$ZENITH_ENVIRONMENTID" != "" ]; then
        kubeconfig="kubeconfig-$ZENITH_ENVIRONMENTID";
    fi

    highlight_message "HINTS AND TIPS"

    if [ "$ZENITH_KUBERNETES_TYPE" == "rosa" ] || [ "$ZENITH_KUBERNETES_TYPE" == "crc" ] || [ "$ZENITH_KUBERNETES_TYPE" == "okd" ]; then
        echo -e "Login to your Openshift Cluster using following command."
        echo -e "${green}oc login${reset}\n"
    else	    
        echo -e "Define the following environment variable to access your cluster."
        echo -e "${green}export KUBECONFIG=$kube_dir/$kubeconfig${reset}\n"
    fi

    echo -e "The environment should be created now. So, run the following command to deploy Zenith services there"
    echo -e "${green}./zenith-services.sh create${reset}\n"

    if [ "$ZENITH_KUBERNETES_TYPE" == "eks" ]; then
        local expiration=$(get_current_expiration_time);
        echo -e "The EKS environment will expire ${red}$expiration (UTC)${reset}";
    fi
}

show_help() {
    local blue=`tput setaf 4`
    local green=`tput setaf 2`
    local reset=`tput sgr0`

    highlight_message "HELP"
    echo -e "Run zenith-infra to create the infrastructure required to install Zenith services."
    echo -e "Remember that you need to configure ${green}.env file${reset} before executing it.\n"

    echo -e "zenith-infra.sh <action>\n"

    echo -e "Parameters:"
    echo -e "  - action: ${blue}MANDATORY${reset}. It is the action to be performed."
    echo -e "     * ${green}create${reset}: \tIt creates the environment infrastructure."
    echo -e "     * ${green}remove${reset}: \tIt removes the environment infrastructure.\n\t\tIf you add the ${green}--quiet${reset} parameter at the end, confirmation messages will be skipped."
    echo -e "     * ${green}export-logs${reset}: \tIt generates the pods logs and description information and store it into zip file"
    echo -e "     * ${green}help${reset}: \tIt displays the help."
    echo -e ""
}


write_output() {
    local kubeconfig="zenith-kubeconfig";

    if [ "$ZENITH_ENVIRONMENTID" != "" ]; then
        kubeconfig="kubeconfig-$ZENITH_ENVIRONMENTID";
    fi

    echo "" > $kube_dir/.configuration

    if [ "$skip_cluster_creation" == "false" ]; then
        echo "ZENITH_INFRA_KUBECONFIG=$kube_dir/$kubeconfig" >> $kube_dir/.configuration
    fi

    if [ "$external_database" == "false" ]; then
        local database_host="$(get_database_service)";
        local database_port="$(get_database_port)";

        echo "ZENITH_INFRA_DATABASE_HOST=$database_host" >> $kube_dir/.configuration
        echo "ZENITH_INFRA_DATABASE_PORT=$database_port" >> $kube_dir/.configuration

        if [ "$ZENITH_DATABASE_PROVIDER" == "postgresql" ]; then
            echo "ZENITH_INFRA_POSTGRESQL_USERNAME=$ZENITH_POSTGRESQL_USERNAME" >> $kube_dir/.configuration
            echo "ZENITH_INFRA_POSTGRESQL_PASSWORD=$ZENITH_POSTGRESQL_PASSWORD" >> $kube_dir/.configuration
            echo "ZENITH_INFRA_POSTGRESQL_DBNAME_AI=$ZENITH_POSTGRESQL_DBNAME_AI" >> $kube_dir/.configuration
            echo "ZENITH_INFRA_POSTGRESQL_DBNAME_DIRECTORY=$ZENITH_POSTGRESQL_DBNAME_DIRECTORY" >> $kube_dir/.configuration
            echo "ZENITH_INFRA_POSTGRESQL_DBNAME_TENANT=$ZENITH_POSTGRESQL_DBNAME_TENANT" >> $kube_dir/.configuration
            echo "ZENITH_INFRA_POSTGRESQL_DBNAME_IDP=$ZENITH_POSTGRESQL_DBNAME_IDP" >> $kube_dir/.configuration
            echo "ZENITH_INFRA_POSTGRESQL_DBNAME_PORTAL=$ZENITH_POSTGRESQL_DBNAME_PORTAL" >> $kube_dir/.configuration
            echo "ZENITH_INFRA_POSTGRESQL_DBNAME_PORTALRT=$ZENITH_POSTGRESQL_DBNAME_PORTALRT" >> $kube_dir/.configuration
            echo "ZENITH_INFRA_POSTGRESQL_DBNAME_PRS=$ZENITH_POSTGRESQL_DBNAME_PRS" >> $kube_dir/.configuration
            echo "ZENITH_INFRA_POSTGRESQL_DBNAME_STUDIO=$ZENITH_POSTGRESQL_DBNAME_STUDIO" >> $kube_dir/.configuration
            echo "ZENITH_INFRA_POSTGRESQL_DBNAME_PROCESS_ENGINE=$ZENITH_POSTGRESQL_DBNAME_PROCESS_ENGINE" >> $kube_dir/.configuration
            echo "ZENITH_INFRA_POSTGRESQL_DBNAME_PROCESS_ENGINE_ROOT=$ZENITH_POSTGRESQL_DBNAME_PROCESS_ENGINE_ROOT" >> $kube_dir/.configuration
            echo "ZENITH_INFRA_POSTGRESQL_DBNAME_METRICS=$ZENITH_POSTGRESQL_DBNAME_METRICS" >> $kube_dir/.configuration
            echo "ZENITH_INFRA_POSTGRESQL_DBNAME_POLICY=$ZENITH_POSTGRESQL_DBNAME_POLICY" >> $kube_dir/.configuration
            echo "ZENITH_INFRA_POSTGRESQL_DBNAME_MOBIUS=$ZENITH_POSTGRESQL_DBNAME_MOBIUS" >> $kube_dir/.configuration
            echo "ZENITH_INFRA_POSTGRESQL_DBNAME_MOBIUSVIEW=$ZENITH_POSTGRESQL_DBNAME_MOBIUSVIEW" >> $kube_dir/.configuration
            echo "ZENITH_INFRA_POSTGRESQL_DBNAME_EVENTANALYTICS=$ZENITH_POSTGRESQL_DBNAME_EVENTANALYTICS" >> $kube_dir/.configuration
            echo "ZENITH_INFRA_POSTGRESQL_DBNAME_AUTHORIZATION=$ZENITH_POSTGRESQL_DBNAME_AUTHORIZATION" >> $kube_dir/.configuration
        else
            echo "ZENITH_INFRA_ORACLE_TNSNAMES_FILE=$ZENITH_ORACLE_TNSNAMES_FILE" >> $kube_dir/.configuration
            echo "ZENITH_INFRA_ORACLE_SQLNET_FILE=$ZENITH_ORACLE_SQLNET_FILE" >> $kube_dir/.configuration
            echo "ZENITH_INFRA_ORACLE_CONNECTDATA_SERVICENAME=$ZENITH_ORACLE_CONNECTDATA_SERVICENAME" >> $kube_dir/.configuration
            echo "ZENITH_INFRA_ORACLE_TNS_ALIAS=$ZENITH_ORACLE_TNS_ALIAS" >> $kube_dir/.configuration
            echo "ZENITH_INFRA_ORACLE_USER_AI=$ZENITH_ORACLE_USER_AI" >> $kube_dir/.configuration
            echo "ZENITH_INFRA_ORACLE_USER_DIRECTORY=$ZENITH_ORACLE_USER_DIRECTORY" >> $kube_dir/.configuration
            echo "ZENITH_INFRA_ORACLE_USER_TENANT=$ZENITH_ORACLE_USER_TENANT" >> $kube_dir/.configuration
            echo "ZENITH_INFRA_ORACLE_USER_IDP=$ZENITH_ORACLE_USER_IDP" >> $kube_dir/.configuration
            echo "ZENITH_INFRA_ORACLE_USER_PORTAL=$ZENITH_ORACLE_USER_PORTAL" >> $kube_dir/.configuration
            echo "ZENITH_INFRA_ORACLE_USER_PORTALRT=$ZENITH_ORACLE_USER_PORTALRT" >> $kube_dir/.configuration
            echo "ZENITH_INFRA_ORACLE_USER_PRS=$ZENITH_ORACLE_USER_PRS" >> $kube_dir/.configuration
            echo "ZENITH_INFRA_ORACLE_USER_STUDIO=$ZENITH_ORACLE_USER_STUDIO" >> $kube_dir/.configuration
            echo "ZENITH_INFRA_ORACLE_USER_PROCESS_ENGINE=$ZENITH_ORACLE_USER_PROCESS_ENGINE" >> $kube_dir/.configuration
            echo "ZENITH_INFRA_ORACLE_USER_PROCESS_ENGINE_ROOT=$ZENITH_ORACLE_USER_PROCESS_ENGINE_ROOT" >> $kube_dir/.configuration
            echo "ZENITH_INFRA_ORACLE_USER_METRICS=$ZENITH_ORACLE_USER_METRICS" >> $kube_dir/.configuration
            echo "ZENITH_INFRA_ORACLE_USER_POLICY=$ZENITH_ORACLE_USER_POLICY" >> $kube_dir/.configuration
            echo "ZENITH_INFRA_ORACLE_USER_MOBIUS=$ZENITH_ORACLE_USER_MOBIUS" >> $kube_dir/.configuration
            echo "ZENITH_INFRA_ORACLE_USER_MOBIUSVIEW=$ZENITH_ORACLE_USER_MOBIUSVIEW" >> $kube_dir/.configuration
            echo "ZENITH_INFRA_ORACLE_USER_EVENTANALYTICS=$ZENITH_ORACLE_USER_EVENTANALYTICS" >> $kube_dir/.configuration
            echo "ZENITH_INFRA_ORACLE_USER_AUTHORIZATION=$ZENITH_ORACLE_USER_AUTHORIZATION" >> $kube_dir/.configuration
            echo "ZENITH_INFRA_ORACLE_PASSWORD_AI=$ZENITH_ORACLE_PASSWORD_AI" >> $kube_dir/.configuration
            echo "ZENITH_INFRA_ORACLE_PASSWORD_DIRECTORY=$ZENITH_ORACLE_PASSWORD_DIRECTORY" >> $kube_dir/.configuration
            echo "ZENITH_INFRA_ORACLE_PASSWORD_TENANT=$ZENITH_ORACLE_PASSWORD_TENANT" >> $kube_dir/.configuration
            echo "ZENITH_INFRA_ORACLE_PASSWORD_IDP=$ZENITH_ORACLE_PASSWORD_IDP" >> $kube_dir/.configuration
            echo "ZENITH_INFRA_ORACLE_PASSWORD_PORTAL=$ZENITH_ORACLE_PASSWORD_PORTAL" >> $kube_dir/.configuration
            echo "ZENITH_INFRA_ORACLE_PASSWORD_PORTALRT=$ZENITH_ORACLE_PASSWORD_PORTALRT" >> $kube_dir/.configuration
            echo "ZENITH_INFRA_ORACLE_PASSWORD_PRS=$ZENITH_ORACLE_PASSWORD_PRS" >> $kube_dir/.configuration
            echo "ZENITH_INFRA_ORACLE_PASSWORD_STUDIO=$ZENITH_ORACLE_PASSWORD_STUDIO" >> $kube_dir/.configuration
            echo "ZENITH_INFRA_ORACLE_PASSWORD_PROCESS_ENGINE=$ZENITH_ORACLE_PASSWORD_PROCESS_ENGINE" >> $kube_dir/.configuration
            echo "ZENITH_INFRA_ORACLE_PASSWORD_PROCESS_ENGINE_ROOT=$ZENITH_ORACLE_PASSWORD_PROCESS_ENGINE_ROOT" >> $kube_dir/.configuration
            echo "ZENITH_INFRA_ORACLE_PASSWORD_METRICS=$ZENITH_ORACLE_PASSWORD_METRICS" >> $kube_dir/.configuration
            echo "ZENITH_INFRA_ORACLE_PASSWORD_POLICY=$ZENITH_ORACLE_PASSWORD_POLICY" >> $kube_dir/.configuration
            echo "ZENITH_INFRA_ORACLE_PASSWORD_MOBIUS=$ZENITH_ORACLE_PASSWORD_MOBIUS" >> $kube_dir/.configuration
            echo "ZENITH_INFRA_ORACLE_PASSWORD_MOBIUSVIEW=$ZENITH_ORACLE_PASSWORD_MOBIUSVIEW" >> $kube_dir/.configuration
            echo "ZENITH_INFRA_ORACLE_PASSWORD_EVENTANALYTICS=$ZENITH_ORACLE_PASSWORD_EVENTANALYTICS" >> $kube_dir/.configuration
            echo "ZENITH_INFRA_ORACLE_PASSWORD_AUTHORIZATION=$ZENITH_ORACLE_PASSWORD_AUTHORIZATION" >> $kube_dir/.configuration
        fi
    fi
}


xargsflag="-d"
if [ $(uname -s) == "Darwin" ]; then
 xargsflag="-I"
fi
export $(grep -v '^#' .env | xargs ${xargsflag} '\n')
kube_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
[ -d "$kube_dir" ] || {
    echo "FATAL: no current dir (maybe running in zsh?)"
    exit 1
}

source "$kube_dir/database/database.sh"
source "$kube_dir/common/common.sh"
source "$kube_dir/common/local_kube.sh"
source "$kube_dir/eks/kube.sh"
source "$kube_dir/common/settings.sh"
source "$kube_dir/registry/local_registry.sh"
source "$kube_dir/dns/dns.sh"
source "$kube_dir/ssl/ssl_certificates.sh"
source "$kube_dir/automationnext/mainframe-emu.sh"
source "$kube_dir/zenith/zenith.sh"
source "$kube_dir/common/templates.sh"
source "$kube_dir/common/volumes.sh"
source "$kube_dir/validate/validate.sh"
source "$kube_dir/kafka/kafka.sh"
source "$kube_dir/export-logs/export-logs.sh"

REMOVE_ENVIRONMENT=false
ZENITH_STAGE=infra
QUIET_MODE=false
EXPORT_LOGS_ZENITH=false

if [ $# -ge 1 ]; then
    args=("$@")

    if [ $# -ge 2 ]; then
        if [ "${args[1]}" == "--quiet" ]; then
            QUIET_MODE=true
        fi
    fi

    if [ "${args[0]}" == "remove" ]; then
        REMOVE_ENVIRONMENT=true
        answer="$(ask_binary_question "Do you want to remove the infrastructure you have in place? (Y/N)" $QUIET_MODE)";
        if [ "$answer" == "N" ]; then
            echo "Operation cancelled."
            exit 1
        fi
    elif [ "${args[0]}" == "create" ]; then
        REMOVE_ENVIRONMENT=false
    elif [ "${args[0]}" == "export-logs" ]; then
        EXPORT_LOGS_ZENITH=true
    else
        show_help;
        exit 1
    fi
else 
    show_help;
    exit 1
fi

set_configuration;
kube_init;

#if [ "$ZENITH_KUBERNETES_TYPE" = "crc" ]; then
#
#    oc login -u kubeadmin https://api.crc.testing:6443
#
#fi

if [ "$EXPORT_LOGS_ZENITH" == "true" ]; then
    if [ $# -ge 2 ]; then
        current_namespace=${args[1]};
    else
        current_namespace="shared"
    fi

    highlight_message "Generating Pods logs and description for $current_namespace namespace"
    export_logs $current_namespace

elif [ "$REMOVE_ENVIRONMENT" == "false" ]; then

    highlight_message "Create/Access Kubernetes Cluster"

    if [ "$skip_cluster_creation" == "true" ]; then

        info_message "Using an existing Kubernetes cluster"
        check_cluster_connection;

    else
        if [ "$ZENITH_KUBERNETES_TYPE" == "eks" ]; then

            if [ "$ZENITH_EKS_USERNAME" == "" ] || [ "$ZENITH_EKS_EMAIL" == "" ] ; then
                error_message "Settings are incorrect. When you run the deployment in EKS, you need to configure ZENITH_EKS_USERNAME and ZENITH_EKS_EMAIL.";
                exit 1
            fi

            info_message "Creating a new cluster in EKS"
            create_eks_cluster;
            create_eks_deployment_conf;
            eks_check_cluster_connection;
            restart_aws_autoscaler;

        else
            info_message "Creating a new local cluster"
            create_local_cluster;

            highlight_message "Configuring DNS server"
            pushd $kube_dir/dns
            configure_dns;
            popd
        fi
    fi

    highlight_message "Installing and configuring Istio"

    pushd $kube_dir/istio
    install_istio;
    popd

    if [ "$ZENITH_KUBERNETES_TYPE" == "k3d" ] || [ "$ZENITH_KUBERNETES_TYPE" == "minikube" ] || [ "$ZENITH_KUBERNETES_TYPE" == "crc" ] || [ "$ZENITH_KUBERNETES_TYPE" == "eks" ] || [ "$ZENITH_KUBERNETES_TYPE" == "rosa" ]; then
        highlight_message "Creating SSL certificate"
        pushd $kube_dir/ssl
        create_ssl_certificate $ZENITH_DOMAIN;
        popd
    fi

    highlight_message "Deploying database services"

    pushd $kube_dir/pull-secrets
    create_kubernetes_namespace $DATABASE_NAMESPACE;
    enable_istio $DATABASE_NAMESPACE;
    apply_pullsecrets $DATABASE_NAMESPACE;
    popd

    if [ "$external_database" == "false" ]; then
        pushd $kube_dir/database
        install_database;

        info_progress_header "Waiting for database services to be ready ...";
        wait_for_database_ready;
        info_message "The database services are ready now.";

        postinstall_database;
        popd

        if [ "$ZENITH_KUBERNETES_TYPE" == "k3d" ] && ! [ "$AUTOMATIONNEXT_ENABLE" == "true" ]; then
            pushd $kube_dir/zenith
            create_kubernetes_namespace $ZENITH_NAMESPACE;
            create_storage_files_from_templates "zenith" $ZENITH_NAMESPACE;
            popd
        fi
    else
        info_message "Skip database services deployment because the environment will use an external database server."
    fi

    if [ "$KAFKA_ENABLED" == "true" ]; then
        highlight_message "Installing kafka"
        create_kubernetes_namespace $KAFKA_NAMESPACE;
        install_kafka;
        wait_for_kafka_ready;
    fi

    highlight_message "Installing emulators"
    
    install_emu;

    write_output;
    show_hints;
    setupniterradb;
else
    if [ "$ZENITH_KUBERNETES_TYPE" == "k3d" ] || [ "$ZENITH_KUBERNETES_TYPE" == "minikube" ] || [ "$ZENITH_KUBERNETES_TYPE" == "crc" ] || [ "$ZENITH_KUBERNETES_TYPE" == "eks" ] || [ "$ZENITH_KUBERNETES_TYPE" == "rosa" ]; then
        highlight_message "Removing SSL certificate from the files"
        pushd $kube_dir/ssl
        remove_ssl_certificate;
        popd
    fi

    if [ "$skip_cluster_creation" == "true" ]; then

        check_cluster_connection;

        pushd $kube_dir/zenith
        uninstall_zenith;
        popd
        
        pushd $kube_dir/database
        uninstall_database;
        popd

        uninstall_emu;

    else

        if [ "$ZENITH_KUBERNETES_TYPE" == "eks" ]; then
            delete_eks_cluster;
            remove_eks_deployment_conf;
        else
            kube_init;
            kube_delete_cluster "${CLUSTER_NAME:-zenith}";
        fi
    fi

fi
