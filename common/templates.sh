#!/bin/bash

source "$kube_dir/common/common.sh"

set_pull_policy() {
    # $1 -> filename
    # $2 -> pull policy tag 
    # $3 -> version
    local pull_policy="IfNotPresent";

    #if [[ $3 == develop ]] || [[ $3 == release_* ]] ; then
    #    pull_policy="Always"
    #fi
    if [[ $3 == develop ]]; then
        pull_policy="Always"
    fi
    replace_tag_in_file $1 $2 $pull_policy;
}

set_default_values() {
        ZENITH_SERVICE_IDP_ENABLED="${ZENITH_SERVICE_IDP_ENABLED:-true}"
    ZENITH_SERVICE_DIRECTORY_ENABLED="${ZENITH_SERVICE_DIRECTORY_ENABLED:-true}"
    ZENITH_SERVICE_AI_ENABLED="${ZENITH_SERVICE_AI_ENABLED:-true}"
    ZENITH_SERVICE_AI_FRAMEWORK_ENABLED="${ZENITH_SERVICE_AI_FRAMEWORK_ENABLED:-true}"
    ZENITH_SERVICE_CONSOLE_ENABLED="${ZENITH_SERVICE_CONSOLE_ENABLED:-true}"
    ZENITH_SERVICE_TENANT_ENABLED="${ZENITH_SERVICE_TENANT_ENABLED:-true}"
    ZENITH_SERVICE_TOKEN_ENABLED="${ZENITH_SERVICE_TOKEN_ENABLED:-true}"
    ZENITH_SERVICE_PORTAL_ENABLED="${ZENITH_SERVICE_PORTAL_ENABLED:-true}"
    ZENITH_SERVICE_PRS_ENABLED="${ZENITH_SERVICE_PRS_ENABLED:-true}"
    ZENITH_SERVICE_PROCESS_ENGINE_ENABLED="${ZENITH_SERVICE_PROCESS_ENGINE_ENABLED:-true}"
    ZENITH_SERVICE_STUDIO_ENABLED="${ZENITH_SERVICE_STUDIO_ENABLED:-true}"
    ZENITH_SERVICE_METRIC_ENABLED="${ZENITH_SERVICE_METRIC_ENABLED:-true}"
    ZENITH_SERVICE_POLICY_ENABLED="${ZENITH_SERVICE_POLICY_ENABLED:-true}"
    ZENITH_SERVICE_MOBIUS_SERVER_ENABLED="${ZENITH_SERVICE_MOBIUS_SERVER_ENABLED:-true}"
    ZENITH_SERVICE_MOBIUS_VIEW_ENABLED="${ZENITH_SERVICE_MOBIUS_VIEW_ENABLED:-true}"
    ZENITH_SERVICE_EVENTANALYTICS_ENABLED="${ZENITH_SERVICE_EVENTANALYTICS_ENABLED:-true}"
    ZENITH_SERVICE_AUTHORIZATION_ENABLED="${ZENITH_SERVICE_AUTHORIZATION_ENABLED:-true}"
    GLOBAL_TIMEOUT_MS="${GLOBAL_TIMEOUT_MS:-75000}"
    GLOBAL_CONNECT_TIMEOUT_MS="${GLOBAL_CONNECT_TIMEOUT_MS:-4000}"
    GLOBAL_IDLE_TIMEOUT_MS="${GLOBAL_IDLE_TIMEOUT_MS:-500000}"
    KAFKA_THREAD_MAX_VALUE="${KAFKA_THREAD_MAX_VALUE:-100}"
    KAFKA_THREAD_CORE_VALUE="${KAFKA_THREAD_CORE_VALUE:-50}"
    ENCRYPTIONRULES_ENABLED="${ENCRYPTIONRULES_ENABLED:-false}"
    KAFKA_PROTOCOL="${KAFKA_PROTOCOL:-PLAINTEXT}"

    ENCRYPTIONRULE1_URLPATTERN1="${ENCRYPTIONRULE1_URLPATTERN1:-null}"
    ENCRYPTIONRULE1_URLPATTERN2="${ENCRYPTIONRULE1_URLPATTERN2:-null}"
    ENCRYPTIONRULE1_URLPATTERN3="${ENCRYPTIONRULE1_URLPATTERN3:-null}"
    ENCRYPTIONRULE1_HOST1="${ENCRYPTIONRULE1_HOST1:-null}"
    ENCRYPTIONRULE1_HOST2="${ENCRYPTIONRULE1_HOST2:-null}"
    ENCRYPTIONRULE1_HOST3="${ENCRYPTIONRULE1_HOST3:-null}"
    ENCRYPTIONRULE1_ENCRYPTIONKEY="${ENCRYPTIONRULE1_ENCRYPTIONKEY:-null}"
    ENCRYPTIONRULE2_URLPATTERN1="${ENCRYPTIONRULE2_URLPATTERN1:-null}"
    ENCRYPTIONRULE2_URLPATTERN2="${ENCRYPTIONRULE2_URLPATTERN2:-null}"
    ENCRYPTIONRULE2_URLPATTERN3="${ENCRYPTIONRULE2_URLPATTERN3:-null}"
    ENCRYPTIONRULE2_HOST1="${ENCRYPTIONRULE2_HOST1:-null}"
    ENCRYPTIONRULE2_HOST2="${ENCRYPTIONRULE2_HOST2:-null}"
    ENCRYPTIONRULE2_HOST3="${ENCRYPTIONRULE2_HOST3:-null}"
    ENCRYPTIONRULE2_ENCRYPTIONKEY="${ENCRYPTIONRULE2_ENCRYPTIONKEY:-null}"
    ENCRYPTIONRULE3_URLPATTERN1="${ENCRYPTIONRULE3_URLPATTERN1:-null}"
    ENCRYPTIONRULE3_URLPATTERN2="${ENCRYPTIONRULE3_URLPATTERN2:-null}"
    ENCRYPTIONRULE3_URLPATTERN3="${ENCRYPTIONRULE3_URLPATTERN3:-null}"
    ENCRYPTIONRULE3_HOST1="${ENCRYPTIONRULE3_HOST1:-null}"
    ENCRYPTIONRULE2_HOST2="${ENCRYPTIONRULE3_HOST2:-null}"
    ENCRYPTIONRULE3_HOST3="${ENCRYPTIONRULE3_HOST3:-null}"
    ENCRYPTIONRULE3_ENCRYPTIONKEY="${ENCRYPTIONRULE3_ENCRYPTIONKEY:-null}"
    ENCRYPTIONRULE4_URLPATTERN1="${ENCRYPTIONRULE4_URLPATTERN1:-null}"
    ENCRYPTIONRULE4_URLPATTERN2="${ENCRYPTIONRULE4_URLPATTERN2:-null}"
    ENCRYPTIONRULE4_URLPATTERN3="${ENCRYPTIONRULE4_URLPATTERN3:-null}"
    ENCRYPTIONRULE4_HOST1="${ENCRYPTIONRULE4_HOST1:-null}"
    ENCRYPTIONRULE4_HOST2="${ENCRYPTIONRULE4_HOST2:-null}"
    ENCRYPTIONRULE4_HOST3="${ENCRYPTIONRULE4_HOST3:-null}"
    ENCRYPTIONRULE4_ENCRYPTIONKEY="${ENCRYPTIONRULE4_ENCRYPTIONKEY:-null}"
    ENCRYPTIONRULE5_URLPATTERN1="${ENCRYPTIONRULE5_URLPATTERN1:-null}"
    ENCRYPTIONRULE5_URLPATTERN2="${ENCRYPTIONRULE5_URLPATTERN2:-null}"
    ENCRYPTIONRULE5_URLPATTERN3="${ENCRYPTIONRULE5_URLPATTERN3:-null}"
    ENCRYPTIONRULE5_HOST1="${ENCRYPTIONRULE5_HOST1:-null}"
    ENCRYPTIONRULE5_HOST2="${ENCRYPTIONRULE5_HOST2:-null}"
    ENCRYPTIONRULE5_HOST3="${ENCRYPTIONRULE5_HOST3:-null}"
    ENCRYPTIONRULE5_ENCRYPTIONKEY="${ENCRYPTIONRULE5_ENCRYPTIONKEY:-null}"
    ENCRYPTIONRULE6_URLPATTERN1="${ENCRYPTIONRULE6_URLPATTERN1:-null}"
    ENCRYPTIONRULE6_URLPATTERN2="${ENCRYPTIONRULE6_URLPATTERN2:-null}"
    ENCRYPTIONRULE6_URLPATTERN3="${ENCRYPTIONRULE6_URLPATTERN3:-null}"
    ENCRYPTIONRULE6_HOST1="${ENCRYPTIONRULE6_HOST1:-null}"
    ENCRYPTIONRULE6_HOST2="${ENCRYPTIONRULE6_HOST2:-null}"
    ENCRYPTIONRULE6_HOST3="${ENCRYPTIONRULE6_HOST3:-null}"
    ENCRYPTIONRULE6_ENCRYPTIONKEY="${ENCRYPTIONRULE6_ENCRYPTIONKEY:-null}"
    ENCRYPTIONRULE7_URLPATTERN1="${ENCRYPTIONRULE7_URLPATTERN1:-null}"
    ENCRYPTIONRULE7_URLPATTERN2="${ENCRYPTIONRULE7_URLPATTERN2:-null}"
    ENCRYPTIONRULE7_URLPATTERN3="${ENCRYPTIONRULE7_URLPATTERN3:-null}"
    ENCRYPTIONRULE7_HOST1="${ENCRYPTIONRULE7_HOST1:-null}"
    ENCRYPTIONRULE7_HOST2="${ENCRYPTIONRULE7_HOST2:-null}"
    ENCRYPTIONRULE7_HOST3="${ENCRYPTIONRULE7_HOST3:-null}"
    ENCRYPTIONRULE7_ENCRYPTIONKEY="${ENCRYPTIONRULE7_ENCRYPTIONKEY:-null}"
    ENCRYPTIONRULE8_URLPATTERN1="${ENCRYPTIONRULE8_URLPATTERN1:-null}"
    ENCRYPTIONRULE8_URLPATTERN2="${ENCRYPTIONRULE8_URLPATTERN2:-null}"
    ENCRYPTIONRULE8_URLPATTERN3="${ENCRYPTIONRULE8_URLPATTERN3:-null}"
    ENCRYPTIONRULE8_HOST1="${ENCRYPTIONRULE8_HOST1:-null}"
    ENCRYPTIONRULE8_HOST2="${ENCRYPTIONRULE8_HOST2:-null}"
    ENCRYPTIONRULE8_HOST3="${ENCRYPTIONRULE8_HOST3:-null}"
    ENCRYPTIONRULE8_ENCRYPTIONKEY="${ENCRYPTIONRULE8_ENCRYPTIONKEY:-null}"
    ENCRYPTIONRULE9_URLPATTERN1="${ENCRYPTIONRULE9_URLPATTERN1:-null}"
    ENCRYPTIONRULE9_URLPATTERN2="${ENCRYPTIONRULE9_URLPATTERN2:-null}"
    ENCRYPTIONRULE9_URLPATTERN3="${ENCRYPTIONRULE9_URLPATTERN3:-null}"
    ENCRYPTIONRULE9_HOST1="${ENCRYPTIONRULE9_HOST1:-null}"
    ENCRYPTIONRULE9_HOST2="${ENCRYPTIONRULE9_HOST2:-null}"
    ENCRYPTIONRULE9_HOST3="${ENCRYPTIONRULE9_HOST3:-null}"
    ENCRYPTIONRULE9_ENCRYPTIONKEY="${ENCRYPTIONRULE9_ENCRYPTIONKEY:-null}"
}

create_common_conf_file() {
    local conf_file=$1;
    local mobiusview_healthchecks="http://authorization:8888/actuator/health,http://mobius:8080/vdrws/services/IVDRServiceMonitoring";
    local seeding_wait_url="http://asg-mobius-view/mobius/actuator/health";
    local complete_domain="$ZENITH_DOMAIN:$ZENITH_PORT";
    local idp_redirect_uri="https://$complete_domain/*";
    local prs_storage_mode="mobius"
    local enable_mobius="true"
    local current_namespace=$ZENITH_NAMESPACE

    set_default_values;

    if [ "$ZENITH_DISABLE_MOBIUS" == "true" ]; then
        seeding_wait_url="http://asg-portal/api/index.html"
        prs_storage_mode="file"
        ZENITH_SERVICE_MOBIUS_SERVER_ENABLED="false"
        ZENITH_SERVICE_MOBIUS_VIEW_ENABLED="false"
        enable_mobius="false"
    fi

    if [ "$ZENITH_EXTERNAL_MOBIUS" == "true" ]; then
        # External Mobius => disable mobius server only
        info_message "Disabling Mobius server because external Mobius server is used instead";
        ZENITH_SERVICE_MOBIUS_SERVER_ENABLED="false";
        mobiusview_healthchecks="http://authorization:8888/actuator/health";
    fi

    if [ "$ZENITH_PORT" == "443" ] || [ "$ZENITH_KUBERNETES_TYPE" == "eks" ] || [ "$ZENITH_KUBERNETES_TYPE" == "rosa" ]; then
        complete_domain="$ZENITH_DOMAIN";
        idp_redirect_uri="https://$ZENITH_DOMAIN/*";
    fi

    if [ "$AUTOMATIONNEXT_ENABLE" == "true" ]; then
        current_namespace=$AUTOMATIONNEXT_NAMESPACE
    fi    

    replace_tag_in_file $conf_file "<registry>" $ZENITH_REGISTRY;
    replace_tag_in_file $conf_file "<domain>" $complete_domain;
    replace_tag_in_file $conf_file "<version_seedingtool>" $ZENITH_VERSION_SEEDINGTOOL;
    replace_tag_in_file $conf_file "<version_secrettool>" $ZENITH_VERSION_SECRETSEEDING;
    replace_tag_in_file $conf_file "<version_ai>" $ZENITH_VERSION_AISERVICES;
    replace_tag_in_file $conf_file "<version_aiframework>" $ZENITH_VERSION_AISERVICESFRAMEWORK;
    replace_tag_in_file $conf_file "<version_directory>" $ZENITH_VERSION_DIRECTORY;
    replace_tag_in_file $conf_file "<version_tenant>" $ZENITH_VERSION_TENANT;
    replace_tag_in_file $conf_file "<version_token>" $ZENITH_VERSION_TOKEN;
    replace_tag_in_file $conf_file "<version_console>" $ZENITH_VERSION_CONSOLE;
    replace_tag_in_file $conf_file "<version_idp>" $ZENITH_VERSION_IDP;
    replace_tag_in_file $conf_file "<version_portal>" $ZENITH_VERSION_PORTAL;
    replace_tag_in_file $conf_file "<version_prs>" $ZENITH_VERSION_PRS;
    replace_tag_in_file $conf_file "<version_process_engine>" $ZENITH_VERSION_PROCESS_ENGINE;
    replace_tag_in_file $conf_file "<version_studio>" $ZENITH_VERSION_STUDIO;
    replace_tag_in_file $conf_file "<version_metric>" $ZENITH_VERSION_METRIC;
    replace_tag_in_file $conf_file "<version_policy>" $ZENITH_VERSION_POLICY;
    replace_tag_in_file $conf_file "<version_mobius>" $ZENITH_VERSION_MOBIUS;
    replace_tag_in_file $conf_file "<version_mobiusview>" $ZENITH_VERSION_MOBIUSVIEW;
    replace_tag_in_file $conf_file "<version_eventanalytics>" $ZENITH_VERSION_EVENTANALYTICS;
    replace_tag_in_file $conf_file "<version_authorization>" $ZENITH_VERSION_AUTHORIZATION;

    replace_tag_in_file $conf_file "<seeding_wait_url>" $seeding_wait_url;
    replace_tag_in_file $conf_file "<idp_redirect_uri>" $idp_redirect_uri;
    replace_tag_in_file $conf_file "<developer_username>" $DEVELOPER_USERNAME;
    replace_tag_in_file $conf_file "<enable_istio>" $ZENITH_ENABLE_ISTIO;
    replace_tag_in_file $conf_file "<istio_url_ready>" \"$ISTIO_URL_READY\";
    replace_tag_in_file $conf_file "<istio_url_kill>" \"$ISTIO_URL_KILL\";
    replace_tag_in_file $conf_file "<docker_pull_secret>" \"$DOCKER_PULL_SECRET\";
    replace_tag_in_file $conf_file "<prs_storage_mode>" $prs_storage_mode;
    replace_tag_in_file $conf_file "<enable_mobius>" $enable_mobius;

    replace_tag_in_file $conf_file "<rocket_prs_http_timeout>" "$ROCKET_PRS_HTTP_TIMEOUT";
    replace_tag_in_file $conf_file "<KAFKA_NAMESPACE>" "$KAFKA_NAMESPACE";
    replace_tag_in_file $conf_file "<KAFKA_BOOTSTRAP_SERVER>" "$KAFKA_BOOTSTRAP_SERVER";
    replace_tag_in_file $conf_file "<rocket_studio_http_timeout>" "$ROCKET_STUDIO_HTTP_TIMEOUT";
    replace_tag_in_file $conf_file "<your namespace>" \"$current_namespace\";
    replace_tag_in_file $conf_file "<hazelcast_clustering>" "$HAZELCAST_CLUSTERING";
    replace_tag_in_file $conf_file "<mobiusview_healthchecks>" $mobiusview_healthchecks;
    replace_tag_in_file $conf_file "<mobius_host>" "$ZENITH_MOBIUS_SERVER";
    replace_tag_in_file $conf_file "<mobius_port>" "$ZENITH_MOBIUS_PORT";
    replace_tag_in_file $conf_file "<mobius_docserver>" "$ZENITH_MOBIUS_DOC_SERVER";

    replace_tag_in_file $conf_file "<studio_connectiontimeout>" "$STUDIO_CONNECTIONTIMEOUT";
    replace_tag_in_file $conf_file "<studio_minimumidle>" "$STUDIO_MINIMUMIDLE";
    replace_tag_in_file $conf_file "<studio_maximumpoolsize>" "$STUDIO_MAXIMUMPOOLSIZE";
    replace_tag_in_file $conf_file "<studio_idletimeout>" "$STUDIO_IDLETIMEOUT";
    replace_tag_in_file $conf_file "<studio_maxlifetime>" "$STUDIO_MAXLIFETIME";
    replace_tag_in_file $conf_file "<studio_autocommit>" "$STUDIO_AUTOCOMMIT";
    replace_tag_in_file $conf_file "<studio_framwork_log_level>" "$STUDIO_FRAMEWORK_LOG_LEVEL";
    replace_tag_in_file $conf_file "<studio_app_log_level>" "$STUDIO_APP_LOG_LEVEL";
    replace_tag_in_file $conf_file "<studio_ds_pool_size>" "$STUDIO_DS_POOL_SIZE";

    replace_tag_in_file $conf_file "<process_connectiontimeout>" "$PROCESS_CONNECTIONTIMEOUT";
    replace_tag_in_file $conf_file "<process_minimumidle>" "$PROCESS_MINIMUMIDLE";
    replace_tag_in_file $conf_file "<process_maximumpoolsize>" "$PROCESS_MAXIMUMPOOLSIZE";
    replace_tag_in_file $conf_file "<process_idletimeout>" "$PROCESS_IDLETIMEOUT";
    replace_tag_in_file $conf_file "<process_maxlifetime>" "$PROCESS_MAXLIFETIME";
    replace_tag_in_file $conf_file "<process_autocommit>" "$PROCESS_AUTOCOMMIT";
    replace_tag_in_file $conf_file "<process_framwork_log_level>" "$PROCESS_FRAMEWORK_LOG_LEVEL";
    replace_tag_in_file $conf_file "<process_app_log_level>" "$PROCESS_APP_LOG_LEVEL";
    
    replace_tag_in_file $conf_file "<prs_connectiontimeout>" "$PRS_CONNECTIONTIMEOUT";
    replace_tag_in_file $conf_file "<prs_minimumidle>" "$PRS_MINIMUMIDLE";
    replace_tag_in_file $conf_file "<prs_maximumpoolsize>" "$PRS_MAXIMUMPOOLSIZE";
    replace_tag_in_file $conf_file "<prs_idletimeout>" "$PRS_IDLETIMEOUT";
    replace_tag_in_file $conf_file "<prs_maxlifetime>" "$PRS_MAXLIFETIME";
    replace_tag_in_file $conf_file "<prs_autocommit>" "$PRS_AUTOCOMMIT";
    replace_tag_in_file $conf_file "<prs_framwork_log_level>" "$PRS_FRAMEWORK_LOG_LEVEL";
    replace_tag_in_file $conf_file "<prs_app_log_level>" "$PRS_APP_LOG_LEVEL";
    replace_tag_in_file $conf_file "<prs_ds_pool_size>" "$PRS_DS_POOL_SIZE";
    replace_tag_in_file $conf_file "<kafka_thread_max_value>" "$KAFKA_THREAD_MAX_VALUE";
    replace_tag_in_file $conf_file "<kafka_thread_core_value>" "$KAFKA_THREAD_CORE_VALUE";

    replace_tag_in_file $conf_file "<global_timeout_ms>" "$GLOBAL_TIMEOUT_MS";
    replace_tag_in_file $conf_file "<global_connect_timeout_ms>" "$GLOBAL_CONNECT_TIMEOUT_MS";
    replace_tag_in_file $conf_file "<global_idle_timeout_ms>" "$GLOBAL_IDLE_TIMEOUT_MS";
    
    set_pull_policy $conf_file "<pullpolicy_seedingtool>" $ZENITH_VERSION_SEEDINGTOOL;
    set_pull_policy $conf_file "<pullpolicy_secrettool>" $ZENITH_VERSION_SECRETSEEDING;
    set_pull_policy $conf_file "<pullpolicy_ai>" $ZENITH_VERSION_AISERVICES;
    set_pull_policy $conf_file "<pullpolicy_aiframework>" $ZENITH_VERSION_AISERVICESFRAMEWORK;
    set_pull_policy $conf_file "<pullpolicy_directory>" $ZENITH_VERSION_DIRECTORY;
    set_pull_policy $conf_file "<pullpolicy_tenant>" $ZENITH_VERSION_TENANT;
    set_pull_policy $conf_file "<pullpolicy_token>" $ZENITH_VERSION_TOKEN;
    set_pull_policy $conf_file "<pullpolicy_console>" $ZENITH_VERSION_CONSOLE;
    set_pull_policy $conf_file "<pullpolicy_idp>" $ZENITH_VERSION_IDP;
    set_pull_policy $conf_file "<pullpolicy_portal>" $ZENITH_VERSION_PORTAL;
    set_pull_policy $conf_file "<pullpolicy_prs>" $ZENITH_VERSION_PRS;
    set_pull_policy $conf_file "<pullpolicy_process_engine>" $ZENITH_VERSION_PROCESS_ENGINE;
    set_pull_policy $conf_file "<pullpolicy_studio>" $ZENITH_VERSION_STUDIO;
    set_pull_policy $conf_file "<pullpolicy_metric>" $ZENITH_VERSION_METRIC;
    set_pull_policy $conf_file "<pullpolicy_policy>" $ZENITH_VERSION_POLICY;
    set_pull_policy $conf_file "<pullpolicy_mobius>" $ZENITH_VERSION_MOBIUS;
    set_pull_policy $conf_file "<pullpolicy_mobiusview>" $ZENITH_VERSION_MOBIUSVIEW;
    set_pull_policy $conf_file "<pullpolicy_eventanalytics>" $ZENITH_VERSION_EVENTANALYTICS;
    set_pull_policy $conf_file "<pullpolicy_authorization>" $ZENITH_VERSION_AUTHORIZATION;

    enable_services $conf_file;
    configure_common_postgres_resources $conf_file;
    configure_common_secrets $conf_file;
    configure_zbots_settings $conf_file;
    configure_encription_rules $conf_file;
}

configure_zbots_settings() {
    local conf_file=$1;

    replace_tag_in_file $conf_file "<connectiq_web_version>" $AUTOMATIONNEXT_VERSION_CIQ_WEB;
    replace_tag_in_file $conf_file "<connectiq_csd_version>" $AUTOMATIONNEXT_VERSION_CIQ_CSD;
    replace_tag_in_file $conf_file "<automationnext_version>" $AUTOMATIONNEXT_VERSION_AUTOMATION_NEXT;
    replace_tag_in_file $conf_file "<connectiq_web_secret_name>" $AUTOMATIONNEXT_SECRET_NAME_CIQ_WEB;
    replace_tag_in_file $conf_file "<connectiq_web_secret_value>" $AUTOMATIONNEXT_SECRET_VALUE_CIQ_WEB_DB_PASSWORD;
    replace_tag_in_file $conf_file "<host>" $ZENITH_DOMAIN;
    replace_tag_in_file $conf_file "<zenith_port>" $ZENITH_PORT;
    replace_tag_in_file $conf_file "<zenith_http_port>" "$ZENITH_HTTP_PORT";
    replace_tag_in_file $conf_file "<automationnext_port>" $AUTOMATIONNEXT_AUTOMATIONNEXT_PORT;
    replace_tag_in_file $conf_file "<ciq_csd_port1>" $AUTOMATIONNEXT_CIQ_CSD_PORT1;
    replace_tag_in_file $conf_file "<ciq_csd_port2>" $AUTOMATIONNEXT_CIQ_CSD_PORT2;
    replace_tag_in_file $conf_file "<ciq_csd_port3>" $AUTOMATIONNEXT_CIQ_CSD_PORT3;
    replace_tag_in_file $conf_file "<emu_port1>" $EMU_PORT1;
    replace_tag_in_file $conf_file "<emu_port2>" $EMU_PORT2;
    replace_tag_in_file $conf_file "<ciq_web_port>" $AUTOMATIONNEXT_CIQ_WEB_PORT;
}

configure_common_postgres_resources() {
    local conf_file=$1;
 
    replace_tag_in_file $conf_file "<database_host>" $ZENITH_DATABASE_HOST;
    replace_tag_in_file $conf_file "<database_port>" $ZENITH_DATABASE_PORT;
    replace_tag_in_file $conf_file "<database_user>" $ZENITH_POSTGRESQL_USERNAME;
    replace_tag_in_file $conf_file "<database_password>" $ZENITH_POSTGRESQL_PASSWORD;
    replace_tag_in_file $conf_file "<database_name_ai>" $ZENITH_POSTGRESQL_DBNAME_AI;
    replace_tag_in_file $conf_file "<database_name_directory>" $ZENITH_POSTGRESQL_DBNAME_DIRECTORY;
    replace_tag_in_file $conf_file "<database_name_tenant>" $ZENITH_POSTGRESQL_DBNAME_TENANT;
    replace_tag_in_file $conf_file "<database_name_idp>" $ZENITH_POSTGRESQL_DBNAME_IDP;
    replace_tag_in_file $conf_file "<database_name_portalrt>" $ZENITH_POSTGRESQL_DBNAME_PORTALRT;
    replace_tag_in_file $conf_file "<database_name_portal>" $ZENITH_POSTGRESQL_DBNAME_PORTAL;
    replace_tag_in_file $conf_file "<database_name_prs>" $ZENITH_POSTGRESQL_DBNAME_PRS;
    replace_tag_in_file $conf_file "<database_name_studio>" $ZENITH_POSTGRESQL_DBNAME_STUDIO;
    replace_tag_in_file $conf_file "<database_name_process_engine>" $ZENITH_POSTGRESQL_DBNAME_PROCESS_ENGINE;
    replace_tag_in_file $conf_file "<database_name_process_engine_root>" $ZENITH_POSTGRESQL_DBNAME_PROCESS_ENGINE_ROOT;
    replace_tag_in_file $conf_file "<database_name_metrics>" $ZENITH_POSTGRESQL_DBNAME_METRICS;
    replace_tag_in_file $conf_file "<database_name_policy>" $ZENITH_POSTGRESQL_DBNAME_POLICY;
    replace_tag_in_file $conf_file "<database_name_mobius>" $ZENITH_POSTGRESQL_DBNAME_MOBIUS;
    replace_tag_in_file $conf_file "<database_name_mobiusview>" $ZENITH_POSTGRESQL_DBNAME_MOBIUSVIEW;
    replace_tag_in_file $conf_file "<database_name_eventanalytics>" $ZENITH_POSTGRESQL_DBNAME_EVENTANALYTICS;
    replace_tag_in_file $conf_file "<database_name_authorization>" $ZENITH_POSTGRESQL_DBNAME_AUTHORIZATION;
}

configure_common_secrets() {
    local conf_file=$1;

    replace_tag_in_file $conf_file "<asg_console_service_secret_name>" $ASG_CONSOLE_SERVICE_SECRET_NAME;
    replace_tag_in_file $conf_file "<asg_console_service_redis_secret_value>" $ASG_CONSOLE_SERVICE_REDIS_SECRET_VALUE;
    replace_tag_in_file $conf_file "<asg_console_service_rabbitmq_secret_value>" $ASG_CONSOLE_SERVICE_RABBITMQ_SECRET_VALUE;

    replace_tag_in_file $conf_file "<asg_directory_service_secret_name>" $ASG_DIRECTORY_SERVICE_SECRET_NAME;
    replace_tag_in_file $conf_file "<asg_directory_service_secret_value>" $ASG_DIRECTORY_SERVICE_SECRET_VALUE;
    replace_tag_in_file $conf_file "<asg_directory_service_redis_secret_value>" $ASG_DIRECTORY_SERVICE_REDIS_SECRET_VALUE;

    replace_tag_in_file $conf_file "<asg_ai_services_framework_secret_name>" $ASG_AI_SERVICES_FRAMEWORK_SECRET_NAME;
    replace_tag_in_file $conf_file "<asg_ai_services_framework_secret_value>" $ASG_AI_SERVICES_FRAMEWORK_SECRET_VALUE;

    replace_tag_in_file $conf_file "<asg_portal_secret_name>" $ASG_PORTAL_SECRET_NAME;
    replace_tag_in_file $conf_file "<asg_portal_secret_value>" $ASG_PORTAL_SECRET_VALUE;
    replace_tag_in_file $conf_file "<asg_portal_realtime_secret_value>" $ASG_PORTAL_REALTIME_SECRET_VALUE;
    replace_tag_in_file $conf_file "<asg_portal_redis_secret_value>" $ASG_PORTAL_REDIS_SECRET_VALUE;

    replace_tag_in_file $conf_file "<asg_prs_secret_name>" $ASG_PRS_SECRET_NAME;
    replace_tag_in_file $conf_file "<asg_prs_secret_value>" $ASG_PRS_SECRET_VALUE;
    replace_tag_in_file $conf_file "<asg_prs_store_secret_value>" $ASG_PRS_STORE_SECRET_VALUE;

    replace_tag_in_file $conf_file "<asg_studio_secret_name>" $ASG_STUDIO_SECRET_NAME;
    replace_tag_in_file $conf_file "<asg_studio_secret_value>" $ASG_STUDIO_SECRET_VALUE;
    replace_tag_in_file $conf_file "<asg_studio_store_secret_value>" $ASG_STUDIO_STORE_SECRET_VALUE;

    replace_tag_in_file $conf_file "<asg_process_engine_secret_name>" $ASG_PROCESS_ENGINE_SECRET_NAME;
    replace_tag_in_file $conf_file "<asg_process_engine_secret_value>" $ASG_PROCESS_ENGINE_SECRET_VALUE;
    replace_tag_in_file $conf_file "<asg_process_engine_store_secret_value>" $ASG_PROCESS_ENGINE_STORE_SECRET_VALUE;

    replace_tag_in_file $conf_file "<asg_tenant_service_secret_name>" $ASG_TENANT_SERVICE_SECRET_NAME;
    replace_tag_in_file $conf_file "<asg_tenant_service_secret_value>" $ASG_TENANT_SERVICE_SECRET_VALUE;
    replace_tag_in_file $conf_file "<asg_tenant_service_redis_secret_value>" $ASG_TENANT_SERVICE_REDIS_SECRET_VALUE;

    replace_tag_in_file $conf_file "<asg_token_service_secret_name>" $ASG_TOKEN_SERVICE_SECRET_NAME;
    replace_tag_in_file $conf_file "<asg_token_service_secret_value>" $ASG_TOKEN_SERVICE_SECRET_VALUE;

    replace_tag_in_file $conf_file "<asg_mobius_secret_name>" $ASG_MOBIUS_SECRET_NAME;
    replace_tag_in_file $conf_file "<asg_mobius_db_password_secret_value>" $ASG_MOBIUS_DB_PASSWORD_SECRET_VALUE;
    replace_tag_in_file $conf_file "<asg_mobius_db_user_secret_value>" $ASG_MOBIUS_DB_USER_SECRET_VALUE;
    replace_tag_in_file $conf_file "<asg_mobius_db_endpoint_secret_value>" $ASG_MOBIUS_DB_ENDPOINT_SECRET_VALUE;
    replace_tag_in_file $conf_file "<asg_mobius_db_port_secret_value>" $ASG_MOBIUS_DB_PORT_SECRET_VALUE;
    replace_tag_in_file $conf_file "<asg_mobius_db_schema_secret_value>" $ASG_MOBIUS_DB_SCHEMA_SECRET_VALUE;    

    replace_tag_in_file $conf_file "<asg_mobiusview_secret_name>" $ASG_MOBIUSVIEW_SECRET_NAME;
    replace_tag_in_file $conf_file "<asg_mobiusview_db_url_secret_value>" $ASG_MOBIUSVIEW_DB_URL_SECRET_VALUE;
    replace_tag_in_file $conf_file "<asg_mobiusview_db_user_secret_value>" $ASG_MOBIUSVIEW_DB_USER_SECRET_VALUE;
    replace_tag_in_file $conf_file "<asg_mobiusview_db_password_secret_value>" $ASG_MOBIUSVIEW_DB_PASSWORD_SECRET_VALUE;

    replace_tag_in_file $conf_file "<asg_eventanalytics_secret_name>" $ASG_EVENTANALYTICS_SECRET_NAME;
    replace_tag_in_file $conf_file "<asg_eventanalytics_db_url_secret_value>" $ASG_EVENTANALYTICS_DB_URL_SECRET_VALUE;
    replace_tag_in_file $conf_file "<asg_eventanalytics_db_user_secret_value>" $ASG_EVENTANALYTICS_DB_USER_SECRET_VALUE;
    replace_tag_in_file $conf_file "<asg_eventanalytics_db_password_secret_value>" $ASG_EVENTANALYTICS_DB_PASSWORD_SECRET_VALUE;    

    replace_tag_in_file $conf_file "<asg_authorization_secret_name>" $ASG_AUTHORIZATION_SECRET_NAME;
    replace_tag_in_file $conf_file "<asg_authorization_db_url_secret_value>" $ASG_AUTHORIZATION_DB_URL_SECRET_VALUE;
    replace_tag_in_file $conf_file "<asg_authorization_db_user_secret_value>" $ASG_AUTHORIZATION_DB_USER_SECRET_VALUE;
    replace_tag_in_file $conf_file "<asg_authorization_db_password_secret_value>" $ASG_AUTHORIZATION_DB_PASSWORD_SECRET_VALUE;

    replace_tag_in_file $conf_file "<asg_policy_secret_name>" $ASG_POLICY_SECRET_NAME;
    replace_tag_in_file $conf_file "<asg_policy_db_url_secret_value>" $ASG_POLICY_DB_URL_SECRET_VALUE;
    replace_tag_in_file $conf_file "<asg_policy_db_user_secret_value>" $ASG_POLICY_DB_USER_SECRET_VALUE;
    replace_tag_in_file $conf_file "<asg_policy_db_password_secret_value>" $ASG_POLICY_DB_PASSWORD_SECRET_VALUE;

    replace_tag_in_file $conf_file "<asg_metric_secret_name>" $ASG_METRIC_SECRET_NAME;
    replace_tag_in_file $conf_file "<asg_metric_db_url_secret_value>" $ASG_METRIC_DB_URL_SECRET_VALUE;
    replace_tag_in_file $conf_file "<asg_metric_db_user_secret_value>" $ASG_METRIC_DB_USER_SECRET_VALUE;
    replace_tag_in_file $conf_file "<asg_metric_db_password_secret_value>" $ASG_METRIC_DB_PASSWORD_SECRET_VALUE;
}


configure_common_image_resources() {
    local conf_file=$1;
    
    ZENITH_PUBLIC_REGISTRY_SOURCE="${ZENITH_PUBLIC_REGISTRY_SOURCE:-docker.io}";
    ZENITH_PUBLIC_REGISTRY_NAMESPACE="${ZENITH_PUBLIC_REGISTRY_NAMESPACE:-t3z3r2a6}";

    if [ "$ZENITH_PUBLIC_REGISTRY_SOURCE" == "docker.io" ]; then
        ZENITH_BROKER_SERVICE_REPOSITORY="bitnami/rabbitmq"
        ZENITH_EMMISARY_SERVICE_REPOSITORY="datawire/aes"
        ZENITH_EMMISARY_REDIS_SERVICE_REPOSITORY="redis"
        ZENITH_EMMISARY_AGENT_SERVICE_REPOSITORY="emissaryingress/emissary"
        ZENITH_CACHE_SERVICE_REPOSITORY="bitnami/redis"
        ZENITH_MOBIUS_INIT_REPOSITORY="postgres"
        ZENITH_MOBIUSVIEW_INIT_REPOSITORY="centos"
        ZENITH_POLICY_DB_INIT_REPOSITORY="postgres"
        ZENITH_POLICY_DEPENDENCY_INIT_REPOSITORY="centos"
    elif [ "$ZENITH_PUBLIC_REGISTRY_SOURCE" == "public.ecr.aws" ]; then
        ZENITH_BROKER_SERVICE_REPOSITORY="${ZENITH_PUBLIC_REGISTRY_NAMESPACE}/rabbitmq"
        ZENITH_EMMISARY_SERVICE_REPOSITORY="${ZENITH_PUBLIC_REGISTRY_NAMESPACE}/aes"
        ZENITH_EMMISARY_REDIS_SERVICE_REPOSITORY="${ZENITH_PUBLIC_REGISTRY_NAMESPACE}/redis"
        ZENITH_EMMISARY_AGENT_SERVICE_REPOSITORY="${ZENITH_PUBLIC_REGISTRY_NAMESPACE}/emissary-agent"
        ZENITH_CACHE_SERVICE_REPOSITORY="${ZENITH_PUBLIC_REGISTRY_NAMESPACE}/redis"
        ZENITH_MOBIUS_INIT_REPOSITORY="${ZENITH_PUBLIC_REGISTRY_NAMESPACE}/postgresql"
        ZENITH_MOBIUSVIEW_INIT_REPOSITORY="${ZENITH_PUBLIC_REGISTRY_NAMESPACE}/centos"
        ZENITH_POLICY_DB_INIT_REPOSITORY="${ZENITH_PUBLIC_REGISTRY_NAMESPACE}/postgresql"
        ZENITH_POLICY_DEPENDENCY_INIT_REPOSITORY="${ZENITH_PUBLIC_REGISTRY_NAMESPACE}/centos"
    fi

    replace_tag_in_file $conf_file "<image_registry>" $ZENITH_PUBLIC_REGISTRY_SOURCE;
    replace_tag_in_file $conf_file "<broker_service_image_repository>" $ZENITH_BROKER_SERVICE_REPOSITORY;
    replace_tag_in_file $conf_file "<emmissary_image_repository>" $ZENITH_EMMISARY_SERVICE_REPOSITORY;
    replace_tag_in_file $conf_file "<emmissary_redis_image_repository>" $ZENITH_EMMISARY_REDIS_SERVICE_REPOSITORY;
    replace_tag_in_file $conf_file "<emmissary_agent_image_repository>" $ZENITH_EMMISARY_AGENT_SERVICE_REPOSITORY;
    replace_tag_in_file $conf_file "<cache_service_image_repository>" $ZENITH_CACHE_SERVICE_REPOSITORY;
    replace_tag_in_file $conf_file "<mobius_init_image_repository>" $ZENITH_MOBIUS_INIT_REPOSITORY;
    replace_tag_in_file $conf_file "<mobiusview_init_image_repository>" $ZENITH_MOBIUSVIEW_INIT_REPOSITORY;
    replace_tag_in_file $conf_file "<policy_db_init_image_repository>" $ZENITH_POLICY_DB_INIT_REPOSITORY;
    replace_tag_in_file $conf_file "<policy_dependency_init_image_repository>" $ZENITH_POLICY_DEPENDENCY_INIT_REPOSITORY;
}

enable_services() {
    local conf_file=$1;

    replace_tag_in_file $conf_file "<enable_idp>" "$ZENITH_SERVICE_IDP_ENABLED";
    replace_tag_in_file $conf_file "<enable_directory>" "$ZENITH_SERVICE_DIRECTORY_ENABLED";
    replace_tag_in_file $conf_file "<enable_ai>" "$ZENITH_SERVICE_AI_ENABLED";
    replace_tag_in_file $conf_file "<enable_ai_framework>" "$ZENITH_SERVICE_AI_FRAMEWORK_ENABLED";
    replace_tag_in_file $conf_file "<enable_console>" "$ZENITH_SERVICE_CONSOLE_ENABLED";
    replace_tag_in_file $conf_file "<enable_tenant>" "$ZENITH_SERVICE_TENANT_ENABLED";
    replace_tag_in_file $conf_file "<enable_token>" "$ZENITH_SERVICE_TOKEN_ENABLED";
    replace_tag_in_file $conf_file "<enable_portal>" "$ZENITH_SERVICE_PORTAL_ENABLED";
    replace_tag_in_file $conf_file "<enable_prs>" "$ZENITH_SERVICE_PRS_ENABLED";
    replace_tag_in_file $conf_file "<enable_studio>" "$ZENITH_SERVICE_STUDIO_ENABLED";
    replace_tag_in_file $conf_file "<enable_process_engine>" "$ZENITH_SERVICE_PROCESS_ENGINE_ENABLED";
    replace_tag_in_file $conf_file "<enable_metric>" "$ZENITH_SERVICE_METRIC_ENABLED";
    replace_tag_in_file $conf_file "<enable_policy>" "$ZENITH_SERVICE_POLICY_ENABLED";
    replace_tag_in_file $conf_file "<enable_mobius_server>" "$ZENITH_SERVICE_MOBIUS_SERVER_ENABLED";
    replace_tag_in_file $conf_file "<enable_mobius_view>" "$ZENITH_SERVICE_MOBIUS_VIEW_ENABLED";
    replace_tag_in_file $conf_file "<enable_eventanalytics>" "$ZENITH_SERVICE_EVENTANALYTICS_ENABLED";
    replace_tag_in_file $conf_file "<enable_authorization>" "$ZENITH_SERVICE_AUTHORIZATION_ENABLED";
}

configure_encription_rules() {
    local conf_file=$1;

    replace_tag_in_file $conf_file "<encryptionrules_enabled>" "$ENCRYPTIONRULES_ENABLED";

    replace_tag_in_file $conf_file "<encryptionrule1_urlpattern1>" "$ENCRYPTIONRULE1_URLPATTERN1";
    replace_tag_in_file $conf_file "<encryptionrule1_urlpattern2>" "$ENCRYPTIONRULE1_URLPATTERN2";
    replace_tag_in_file $conf_file "<encryptionrule1_urlpattern3>" "$ENCRYPTIONRULE1_URLPATTERN3";
    replace_tag_in_file $conf_file "<encryptionrule1_host1>" "$ENCRYPTIONRULE1_HOST1";
    replace_tag_in_file $conf_file "<encryptionrule1_host2>" "$ENCRYPTIONRULE1_HOST2";
    replace_tag_in_file $conf_file "<encryptionrule1_host3>" "$ENCRYPTIONRULE1_HOST3";
    replace_tag_in_file $conf_file "<encryptionrule1_encryptionkey>" "$ENCRYPTIONRULE1_ENCRYPTIONKEY";

    replace_tag_in_file $conf_file "<encryptionrule2_urlpattern1>" "$ENCRYPTIONRULE2_URLPATTERN1";
    replace_tag_in_file $conf_file "<encryptionrule2_urlpattern2>" "$ENCRYPTIONRULE2_URLPATTERN2";
    replace_tag_in_file $conf_file "<encryptionrule2_urlpattern3>" "$ENCRYPTIONRULE2_URLPATTERN3";
    replace_tag_in_file $conf_file "<encryptionrule2_host1>" "$ENCRYPTIONRULE2_HOST1";
    replace_tag_in_file $conf_file "<encryptionrule2_host2>" "$ENCRYPTIONRULE2_HOST2";
    replace_tag_in_file $conf_file "<encryptionrule2_host3>" "$ENCRYPTIONRULE2_HOST3";
    replace_tag_in_file $conf_file "<encryptionrule2_encryptionkey>" "$ENCRYPTIONRULE2_ENCRYPTIONKEY";

    replace_tag_in_file $conf_file "<encryptionrule3_urlpattern1>" "$ENCRYPTIONRULE3_URLPATTERN1";
    replace_tag_in_file $conf_file "<encryptionrule3_urlpattern2>" "$ENCRYPTIONRULE3_URLPATTERN2";
    replace_tag_in_file $conf_file "<encryptionrule3_urlpattern3>" "$ENCRYPTIONRULE3_URLPATTERN3";
    replace_tag_in_file $conf_file "<encryptionrule3_host1>" "$ENCRYPTIONRULE3_HOST1";
    replace_tag_in_file $conf_file "<encryptionrule3_host2>" "$ENCRYPTIONRULE3_HOST2";
    replace_tag_in_file $conf_file "<encryptionrule3_host3>" "$ENCRYPTIONRULE3_HOST3";
    replace_tag_in_file $conf_file "<encryptionrule3_encryptionkey>" "$ENCRYPTIONRULE3_ENCRYPTIONKEY";

    replace_tag_in_file $conf_file "<encryptionrule4_urlpattern1>" "$ENCRYPTIONRULE4_URLPATTERN1";
    replace_tag_in_file $conf_file "<encryptionrule4_urlpattern2>" "$ENCRYPTIONRULE4_URLPATTERN2";
    replace_tag_in_file $conf_file "<encryptionrule4_urlpattern3>" "$ENCRYPTIONRULE4_URLPATTERN3";
    replace_tag_in_file $conf_file "<encryptionrule4_host1>" "$ENCRYPTIONRULE4_HOST1";
    replace_tag_in_file $conf_file "<encryptionrule4_host2>" "$ENCRYPTIONRULE4_HOST2";
    replace_tag_in_file $conf_file "<encryptionrule4_host3>" "$ENCRYPTIONRULE4_HOST3";
    replace_tag_in_file $conf_file "<encryptionrule4_encryptionkey>" "$ENCRYPTIONRULE4_ENCRYPTIONKEY";

    replace_tag_in_file $conf_file "<encryptionrule5_urlpattern1>" "$ENCRYPTIONRULE5_URLPATTERN1";
    replace_tag_in_file $conf_file "<encryptionrule5_urlpattern2>" "$ENCRYPTIONRULE5_URLPATTERN2";
    replace_tag_in_file $conf_file "<encryptionrule5_urlpattern3>" "$ENCRYPTIONRULE5_URLPATTERN3";
    replace_tag_in_file $conf_file "<encryptionrule5_host1>" "$ENCRYPTIONRULE5_HOST1";
    replace_tag_in_file $conf_file "<encryptionrule5_host2>" "$ENCRYPTIONRULE5_HOST2";
    replace_tag_in_file $conf_file "<encryptionrule5_host3>" "$ENCRYPTIONRULE5_HOST3";
    replace_tag_in_file $conf_file "<encryptionrule5_encryptionkey>" "$ENCRYPTIONRULE5_ENCRYPTIONKEY";

    replace_tag_in_file $conf_file "<encryptionrule6_urlpattern1>" "$ENCRYPTIONRULE6_URLPATTERN1";
    replace_tag_in_file $conf_file "<encryptionrule6_urlpattern2>" "$ENCRYPTIONRULE6_URLPATTERN2";
    replace_tag_in_file $conf_file "<encryptionrule6_urlpattern3>" "$ENCRYPTIONRULE6_URLPATTERN3";
    replace_tag_in_file $conf_file "<encryptionrule6_host1>" "$ENCRYPTIONRULE6_HOST1";
    replace_tag_in_file $conf_file "<encryptionrule6_host2>" "$ENCRYPTIONRULE6_HOST2";
    replace_tag_in_file $conf_file "<encryptionrule6_host3>" "$ENCRYPTIONRULE6_HOST3";
    replace_tag_in_file $conf_file "<encryptionrule6_encryptionkey>" "$ENCRYPTIONRULE6_ENCRYPTIONKEY";

    replace_tag_in_file $conf_file "<encryptionrule7_urlpattern1>" "$ENCRYPTIONRULE7_URLPATTERN1";
    replace_tag_in_file $conf_file "<encryptionrule7_urlpattern2>" "$ENCRYPTIONRULE7_URLPATTERN2";
    replace_tag_in_file $conf_file "<encryptionrule7_urlpattern3>" "$ENCRYPTIONRULE7_URLPATTERN3";
    replace_tag_in_file $conf_file "<encryptionrule7_host1>" "$ENCRYPTIONRULE7_HOST1";
    replace_tag_in_file $conf_file "<encryptionrule7_host2>" "$ENCRYPTIONRULE7_HOST2";
    replace_tag_in_file $conf_file "<encryptionrule7_host3>" "$ENCRYPTIONRULE7_HOST3";
    replace_tag_in_file $conf_file "<encryptionrule7_encryptionkey>" "$ENCRYPTIONRULE7_ENCRYPTIONKEY";

    replace_tag_in_file $conf_file "<encryptionrule8_urlpattern1>" "$ENCRYPTIONRULE8_URLPATTERN1";
    replace_tag_in_file $conf_file "<encryptionrule8_urlpattern2>" "$ENCRYPTIONRULE8_URLPATTERN2";
    replace_tag_in_file $conf_file "<encryptionrule8_urlpattern3>" "$ENCRYPTIONRULE8_URLPATTERN3";
    replace_tag_in_file $conf_file "<encryptionrule8_host1>" "$ENCRYPTIONRULE8_HOST1";
    replace_tag_in_file $conf_file "<encryptionrule8_host2>" "$ENCRYPTIONRULE8_HOST2";
    replace_tag_in_file $conf_file "<encryptionrule8_host3>" "$ENCRYPTIONRULE8_HOST3";
    replace_tag_in_file $conf_file "<encryptionrule8_encryptionkey>" "$ENCRYPTIONRULE8_ENCRYPTIONKEY";

    replace_tag_in_file $conf_file "<encryptionrule9_urlpattern1>" "$ENCRYPTIONRULE9_URLPATTERN1";
    replace_tag_in_file $conf_file "<encryptionrule9_urlpattern2>" "$ENCRYPTIONRULE9_URLPATTERN2";
    replace_tag_in_file $conf_file "<encryptionrule9_urlpattern3>" "$ENCRYPTIONRULE9_URLPATTERN3";
    replace_tag_in_file $conf_file "<encryptionrule9_host1>" "$ENCRYPTIONRULE9_HOST1";
    replace_tag_in_file $conf_file "<encryptionrule9_host2>" "$ENCRYPTIONRULE9_HOST2";
    replace_tag_in_file $conf_file "<encryptionrule9_host3>" "$ENCRYPTIONRULE9_HOST3";
    replace_tag_in_file $conf_file "<encryptionrule9_encryptionkey>" "$ENCRYPTIONRULE9_ENCRYPTIONKEY";

    replace_tag_in_file $conf_file "<encryptionrule10_urlpattern1>" "$ENCRYPTIONRULE10_URLPATTERN1";
    replace_tag_in_file $conf_file "<encryptionrule10_urlpattern2>" "$ENCRYPTIONRULE10_URLPATTERN2";
    replace_tag_in_file $conf_file "<encryptionrule10_urlpattern3>" "$ENCRYPTIONRULE10_URLPATTERN3";
    replace_tag_in_file $conf_file "<encryptionrule10_host1>" "$ENCRYPTIONRULE10_HOST1";
    replace_tag_in_file $conf_file "<encryptionrule10_host2>" "$ENCRYPTIONRULE10_HOST2";
    replace_tag_in_file $conf_file "<encryptionrule10_host3>" "$ENCRYPTIONRULE10_HOST3";
    replace_tag_in_file $conf_file "<encryptionrule10_encryptionkey>" "$ENCRYPTIONRULE10_ENCRYPTIONKEY";
}

configure_crc_oracle() {
    ZENITH_VALUES_CRC_ORACLE_FILENAME=values-crc-oracle.yaml
    if [ "$ZENITH_KUBERNETES_TYPE" == "crc" ] && [ "$ZENITH_DATABASE_PROVIDER" == "oracle" ]; then
       cp $kube_dir/zenith/templates/$ZENITH_VALUES_CRC_ORACLE_FILENAME $ZENITH_VALUES_CRC_ORACLE_FILENAME
    fi
}

configure_mobius_view_certificates() {
    if [ "$ZENITH_MOBIUSVIEW_ADDITIONAL_CERTIFICATE" != "" ]; then
        base64_certificate=$(cat $ZENITH_MOBIUSVIEW_ADDITIONAL_CERTIFICATE | base64 -w0)
        cp $kube_dir/zenith/templates/mobiusview-crt-screts.yaml mobiusview-crt-screts.yaml
        replace_tag_in_file mobiusview-crt-screts.yaml "<mobiusview_crt_secret>" $base64_certificate;
    fi
}