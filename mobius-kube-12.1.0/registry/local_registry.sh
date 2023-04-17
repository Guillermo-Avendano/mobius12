#!/bin/bash

source "$kube_dir/common/common.sh"

tag_images(){
    local registry_src=${SOURCE_DOCKER_REGISTRY}
    local registry_target=${DNS_LOCALREGISTRY}:${PORT_LOCALREGISTRY}
	
	declare -A images
    images[${IMAGE_NAME_MOBIUS}]=${IMAGE_VERSION_MOBIUS}
    images[${IMAGE_NAME_MOBIUSVIEW}]=${IMAGE_VERSION_MOBIUSVIEW}
	images[${IMAGE_NAME_EVENTANALYTICS}]=${IMAGE_VERSION_EVENTANALYTICS}
	
	for key in ${!images[@]}; do
        $CONTAINER_EXE tag ${registry_src}/${key}:${images[${key}]} ${registry_target}/${key}:${images[${key}]}
    done
}


push_images_to_local_registry(){
    if [ "$REGISTRY_TYPE" == "local" ]; then
        if [ "$PUSH_IMAGES_LOCALREGISTRY" == "true" ]; then
		    info_message "Tag images"
			tag_images;
            info_message "Push images"
            push_images;
        else
            info_message "Skip pushing images to the local registry $NAME_LOCALREGISTRY"
        fi
    fi
}

push_images(){
    local registry_target=${DNS_LOCALREGISTRY}:${PORT_LOCALREGISTRY}

    declare -A images
    images[${IMAGE_NAME_MOBIUS}]=${IMAGE_VERSION_MOBIUS}
    images[${IMAGE_NAME_MOBIUSVIEW}]=${IMAGE_VERSION_MOBIUSVIEW}
	images[${IMAGE_NAME_EVENTANALYTICS}]=${IMAGE_VERSION_EVENTANALYTICS}
    
    for key in ${!images[@]}; do
        $CONTAINER_EXE push ${registry_target}/${key}:${images[${key}]}
    done
}

create_registry(){
    if [ "$REGISTRY_TYPE" == "local" ]; then
        if [ "$CREATE_LOCALREGISTRY" == "true" ]; then
		    if check_registry_exists; then
              delete_registry;
	        fi  
            info_message "Creating registry $NAME_LOCALREGISTRY"
            #$KUBE_EXE registry create $NAME_LOCALREGISTRY --port 0.0.0.0:${PORT_LOCALREGISTRY}
			$KUBE_EXE registry create $NAME_LOCALREGISTRY --port ${PORT_LOCALREGISTRY}
        else 
            info_message "Using existing registry $NAME_LOCALREGISTRY"
        fi
    else
        info_message "Skipping this step as registry REGISTRY_TYPE environemnt variable is not 'local'"
    fi
}

delete_registry(){
    if [ "$REGISTRY_TYPE" == "local" ]; then
        info_message "deleting registry $NAME_LOCALREGISTRY"
        $KUBE_EXE registry delete $NAME_LOCALREGISTRY    
    fi
}

check_registry_exists() {
    #TODO: Needed to add minikube
    $KUBE_EXE registry list 2>/dev/null | grep -q "$NAME_LOCALREGISTRY"
}