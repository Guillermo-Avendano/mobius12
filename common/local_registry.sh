#!/bin/bash

source "$kube_dir/common/common.sh"

login_docker(){
    docker login --username ${DOCKER_USER} --password ${DOCKER_PASS} ${MOBIUS_SOURCE_REGISTRY}
}

pull_images(){
    local registry_src=${MOBIUS_SOURCE_REGISTRY}

    declare -A images
    images["mobius-server"]=${MOBIUS_SERVER_VERSION}
    images["mobius-view"]=${MOBIUS_VIEW_VERSION}
    images["eventanalytics"]=${EVENTANALYTICS_VERSION}


    for key in ${!images[@]}; do
        docker pull ${registry_src}/${key}:${images[${key}]}
    done
}

tag_images(){
    local registry_src=${MOBIUS_SOURCE_REGISTRY}
    local registry_target=${MOBIUS_LOCALREGISTRY_NAME}:${MOBIUS_LOCALREGISTRY_PORT}

    declare -A images
    images["mobius-server"]=${MOBIUS_SERVER_VERSION}
    images["mobius-view"]=${MOBIUS_VIEW_VERSION}
    images["eventanalytics"]=${EVENTANALYTICS_VERSION}

    for key in ${!images[@]}; do
        docker tag ${registry_src}/${key}:${images[${key}]} ${registry_target}/${key}:${images[${key}]}
    done
}

push_images(){
    local registry_target=${MOBIUS_LOCALREGISTRY_NAME}:${MOBIUS_LOCALREGISTRY_PORT}

    declare -A images
    images["mobius-server"]=${MOBIUS_SERVER_VERSION}
    images["mobius-view"]=${MOBIUS_VIEW_VERSION}
    images["eventanalytics"]=${EVENTANALYTICS_VERSION}
    
    docker login $registry_target

    for key in ${!images[@]}; do
        docker push ${registry_target}/${key}:${images[${key}]}
    done
}

push_images_to_local_registry(){

    info_message "Login remote registry"
    login_docker;

    info_message "Pull images"
    pull_images;

    info_message "Tag images"
    tag_images;

    info_message "Push images"
    push_images;

}


