#!/bin/bash

create_storage_files_from_templates() {
    local scope=$1
    local namespace=$2

    cp $kube_dir/zenith/storage/local/templates/idp-pvc.yaml storage/local/idp-pvc.yaml;
    replace_tag_in_file storage/local/idp-pvc.yaml "<ZENITH_IDP_CERTS_PATH>" $(get_idp_volume);

    if [ "$ZENITH_KUBERNETES_TYPE" == "eks" ]; then
        $KUBE_CLI_EXE apply -f $kube_dir/$scope/storage/aws --namespace $namespace
    elif [ "$ZENITH_KUBERNETES_TYPE" == "rosa" ] || [ "$ZENITH_KUBERNETES_TYPE" == "okd" ]; then
        $KUBE_CLI_EXE apply -f $kube_dir/$scope/storage/openshift --namespace $namespace
    else
        $KUBE_CLI_EXE apply -f $kube_dir/$scope/storage/local --namespace $namespace
    fi
}

get_idp_volume() {
    idp_volume_path=`eval echo $KUBE_VOLUME_PATH`
    if [ ! -d $idp_volume_path ]; then
        mkdir -p $idp_volume_path;
        chmod -R 777 $idp_volume_path;
    fi
    echo $idp_volume_path
}
