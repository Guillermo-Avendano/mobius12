#!/bin/bash

source "$kube_dir/common/common.sh"

login_ecr(){
    export AWS_PROFILE=${ZENITH_LOCALREGISTRY_AWSPROFILE}
    aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin ${ZENITH_LOCALREGISTRY_SOURCE_REGISTRY}
}

pull_images_from_ecr(){
    local registry_src=${ZENITH_LOCALREGISTRY_SOURCE_REGISTRY}

    declare -A images
    images["seeding-tool"]=${ZENITH_VERSION_SEEDINGTOOL}
    images["asg-s2s-seeding-tool"]=${ZENITH_VERSION_SECRETSEEDING}
    images["ai-service"]=${ZENITH_VERSION_AISERVICES}
    images["ai-service-framework"]=${ZENITH_VERSION_AISERVICESFRAMEWORK}
    images["directory-service"]=${ZENITH_VERSION_DIRECTORY}
    images["tenant-service"]=${ZENITH_VERSION_TENANT}
    images["token-service"]=${ZENITH_VERSION_TOKEN}
    images["console-service"]=${ZENITH_VERSION_CONSOLE}
    images["idp-service"]=${ZENITH_VERSION_IDP}
    images["portal"]=${ZENITH_VERSION_PORTAL}
    images["prs"]=${ZENITH_VERSION_PRS}
    images["process-engine"]=${ZENITH_VERSION_PROCESS_ENGINE}
    images["studio"]=${ZENITH_VERSION_STUDIO}
    images["metrics-boot"]=${ZENITH_VERSION_METRIC}
    images["policies-boot"]=${ZENITH_VERSION_POLICY}
    images["mobius-server"]=${ZENITH_VERSION_MOBIUS}
    images["mobius-view"]=${ZENITH_VERSION_MOBIUSVIEW}
    images["eventanalytics"]=${ZENITH_VERSION_EVENTANALYTICS}
    images["authorization-common"]=${ZENITH_VERSION_AUTHORIZATION}

    for key in ${!images[@]}; do
        $CONTAINER_EXE pull ${registry_src}/${key}:${images[${key}]}
    done
}

tag_images(){
    local registry_src=${ZENITH_LOCALREGISTRY_SOURCE_REGISTRY}
    local registry_target=${ZENITH_LOCALREGISTRY_DNS}:${ZENITH_LOCALREGISTRY_PORT}

    declare -A images
    images["seeding-tool"]=${ZENITH_VERSION_SEEDINGTOOL}
    images["asg-s2s-seeding-tool"]=${ZENITH_VERSION_SECRETSEEDING}
    images["ai-service"]=${ZENITH_VERSION_AISERVICES}
    images["ai-service-framework"]=${ZENITH_VERSION_AISERVICESFRAMEWORK}
    images["directory-service"]=${ZENITH_VERSION_DIRECTORY}
    images["tenant-service"]=${ZENITH_VERSION_TENANT}
    images["token-service"]=${ZENITH_VERSION_TOKEN}
    images["console-service"]=${ZENITH_VERSION_CONSOLE}
    images["idp-service"]=${ZENITH_VERSION_IDP}
    images["portal"]=${ZENITH_VERSION_PORTAL}
    images["prs"]=${ZENITH_VERSION_PRS}
    images["process-engine"]=${ZENITH_VERSION_PROCESS_ENGINE}
    images["studio"]=${ZENITH_VERSION_STUDIO}
    images["metrics-boot"]=${ZENITH_VERSION_METRIC}
    images["policies-boot"]=${ZENITH_VERSION_POLICY}
    images["mobius-server"]=${ZENITH_VERSION_MOBIUS}
    images["mobius-view"]=${ZENITH_VERSION_MOBIUSVIEW}
    images["eventanalytics"]=${ZENITH_VERSION_EVENTANALYTICS}
    images["authorization-common"]=${ZENITH_VERSION_AUTHORIZATION}

    for key in ${!images[@]}; do
        $CONTAINER_EXE tag ${registry_src}/${key}:${images[${key}]} ${registry_target}/${key}:${images[${key}]}
    done
}

push_images(){
    local registry_target=${ZENITH_LOCALREGISTRY_DNS}:${ZENITH_LOCALREGISTRY_PORT}

    declare -A images
    images["seeding-tool"]=${ZENITH_VERSION_SEEDINGTOOL}
    images["asg-s2s-seeding-tool"]=${ZENITH_VERSION_SECRETSEEDING}
    images["ai-service"]=${ZENITH_VERSION_AISERVICES}
    images["ai-service-framework"]=${ZENITH_VERSION_AISERVICESFRAMEWORK}
    images["directory-service"]=${ZENITH_VERSION_DIRECTORY}
    images["tenant-service"]=${ZENITH_VERSION_TENANT}
    images["token-service"]=${ZENITH_VERSION_TOKEN}
    images["console-service"]=${ZENITH_VERSION_CONSOLE}
    images["idp-service"]=${ZENITH_VERSION_IDP}
    images["portal"]=${ZENITH_VERSION_PORTAL}
    images["prs"]=${ZENITH_VERSION_PRS}
    images["process-engine"]=${ZENITH_VERSION_PROCESS_ENGINE}
    images["studio"]=${ZENITH_VERSION_STUDIO}
    images["metrics-boot"]=${ZENITH_VERSION_METRIC}
    images["policies-boot"]=${ZENITH_VERSION_POLICY}
    images["mobius-server"]=${ZENITH_VERSION_MOBIUS}
    images["mobius-view"]=${ZENITH_VERSION_MOBIUSVIEW}
    images["eventanalytics"]=${ZENITH_VERSION_EVENTANALYTICS}
    images["authorization-common"]=${ZENITH_VERSION_AUTHORIZATION}
    
    for key in ${!images[@]}; do
        $CONTAINER_EXE push ${registry_target}/${key}:${images[${key}]}
    done
}

push_images_to_local_registry(){
    if [ "$ZENITH_REGISTRY_TYPE" == "local" ]; then
        if [ "$ZENITH_LOCALREGISTRY_PUSH_IMAGES" == "true" ]; then
            info_message "Login internal registry"
            login_ecr;

            info_message "Pull images"
            pull_images_from_ecr;

            info_message "Tag images"
            tag_images;

            info_message "Push images"
            push_images;
        else
            info_message "Skip pushing images to the local registry $KUBE_REGISTRY_NAME"
        fi
    fi
}

create_registry(){
    if [ "$ZENITH_REGISTRY_TYPE" == "local" ]; then
        if [ "$ZENITH_LOCALREGISTRY_CREATE" == "true" ]; then
            info_message "Creating registry $KUBE_REGISTRY_NAME"
            $KUBE_EXE registry create $ZENITH_LOCALREGISTRY_NAME --port 0.0.0.0:${ZENITH_LOCALREGISTRY_PORT}
        else 
            info_message "Using existing registry $KUBE_REGISTRY_NAME"
        fi
    else
        info_message "Skipping this step as registry ZENITH_REGISTRY_TYPE environemnt variable is not 'local'"
    fi
}
