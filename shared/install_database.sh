#!/bin/bash
#abort in case of cmd failure
set -Eeuo pipefail

source "../env.sh"
source "../common/common.sh"
source "../database/database.sh"


highlight_message "Deploying database services"

if [ "$external_database" == "false" ]; then
    pushd $kube_dir/database
    install_database;

    info_progress_header "Waiting for database services to be ready ...";
    wait_for_database_ready;
    info_message "The database services are ready now.";

    #postinstall_database;
    popd
else
    info_message "Skip database services deployment because the environment will use an external database server."
fi