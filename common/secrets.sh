#!/bin/bash

create_common_secrets() {
    local namespace=$1

    $KUBE_CLI_EXE apply -f $kube_dir/zenith/secrets --namespace $namespace

    if [ ! -z $ZENITH_MOBIUSVIEW_ADDITIONAL_CERTIFICATE ]; then
        $KUBE_CLI_EXE apply -f mobiusview-crt-screts.yaml --namespace $namespace
    fi
}
