#!/bin/bash

source "$kube_dir/common/common.sh"

# This file is to avoid the Docker pull limits from Docker for anonymous pulls.

docker_set_default_values() {
    DOCKER_REGISTRY="${DOCKER_REGISTRY:-}"
    DOCKER_USERNAME="${DOCKER_USERNAME:-}"
    DOCKER_PASSWORD="${DOCKER_PASSWORD:-}"
    DOCKER_EMAIL="${DOCKER_EMAIL:-}"
}

create_docker_pull_secret() {
    local namespace=$1
    DOCKER_PULL_SECRET='docker-pull-secret'

    if [ "$DOCKER_USERNAME" == "" ]; then
        info_message "Using anonymous pulls to get images from Docker Hub"
    else
        info_message "Using docker-pull-secret pulls to get images from Docker Hub"
        local exists=$(check_if_kubernetes_resource_exists secret $DOCKER_PULL_SECRET $namespace);

        if [ "$exists" == "true" ]; then
            info_message "Using an existing $DOCKER_PULL_SECRET secret"
        else
            $KUBE_CLI_EXE create secret docker-registry $DOCKER_PULL_SECRET --docker-username=$DOCKER_USERNAME --docker-password=$DOCKER_PASSWORD --docker-email=$DOCKER_EMAIL --namespace $namespace
        fi
    fi
}
