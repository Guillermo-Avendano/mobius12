#!/bin/bash

kube_init() {
  if [ "$KUBERNETES_TYPE" == "k3d" ]; then  
    KUBE_EXE="k3d"
    KUBE_CLI_EXE="kubectl"
    CONTAINER_EXE="docker"
  elif [ "$KUBERNETES_TYPE" == "rosa" ]; then
    KUBE_EXE=""
    KUBE_CLI_EXE="oc"
    CONTAINER_EXE="podman"    
  elif [ "$KUBERNETES_TYPE" == "okd" ]; then
    KUBE_EXE=""
    KUBE_CLI_EXE="oc"
    CONTAINER_EXE="podman"
  elif [ "$KUBERNETES_TYPE" == "crc" ]; then
    KUBE_EXE="crc"
    KUBE_CLI_EXE="oc"
    CONTAINER_EXE="podman"
  elif [ "$KUBERNETES_TYPE" == "eks" ]; then
    KUBE_EXE=""
    KUBE_CLI_EXE="kubectl"
    CONTAINER_EXE="docker"
  elif [ "$KUBERNETES_TYPE" == "minikube" ]; then
    KUBE_EXE="minikube"
    if ! command_exists $KUBE_EXE; then
      KUBE_EXE="k3d"
      KUBE_CLI_EXE="kubectl"
      CONTAINER_EXE="docker"
    fi
  fi
}

check_cluster_exists() {
    #TODO: Needed to add minikube
    $KUBE_EXE cluster list 2>/dev/null | grep -q "$KUBE_CLUSTER_NAME"
}

get_kubeconfig() {
  if [ "$KUBERNETES_TYPE" == "k3d" ]; then
    $KUBE_EXE kubeconfig get $KUBE_CLUSTER_NAME 2>/dev/null
  elif [ "$KUBERNETES_TYPE" == "minikube" ]; then
    cat ~/.minikube/profiles/config.json 2>/dev/null
  elif [ "$KUBERNETES_TYPE" == "crc" ]; then
    $KUBE_CLI_EXE config view --raw 2>/dev/null;
  fi
}

save_kubeconfig() {
  if [ "$KUBERNETES_TYPE" == "k3d" ]; then
    $KUBE_EXE kubeconfig get $KUBE_CLUSTER_NAME >"$(pwd)/MOBIUS-kubeconfig"
  elif [ "$KUBERNETES_TYPE" == "minikube" ]; then
    cp ~/.minikube/profiles/$KUBE_CLUSTER_NAME/config.json "$(pwd)/MOBIUS-kubeconfig"
  elif [ "$KUBERNETES_TYPE" == "crc" ]; then
    $KUBE_CLI_EXE config view --raw >"$(pwd)/MOBIUS-kubeconfig";
  fi
}

check_cluster_connection() {
  export KUBECONFIG=$MOBIUS_KUBECONFIG
  info_message "Showing some cluster info:"
  $KUBE_CLI_EXE cluster-info 
}

cluster_connection() {
  kc=$(get_kubeconfig)
  [ -n "$kc" ] || echo "could not obtain a valid KUBECONFIG from $KUBERNETES_TYPE"
  save_kubeconfig;

  MOBIUS_KUBECONFIG="$(pwd)/MOBIUS-kubeconfig"
  check_cluster_connection;
}

export_cluster_config() {
  cluster_connection;
}

create_cluster() {
  info_message "Creating kubernetes cluster $KUBE_CLUSTER_NAME"

  if [ "$REGISTRY_TYPE" == "local" ]; then
    if [ "$KUBERNETES_TYPE" == "k3d" ]; then
      echo $KUBE_EXE cluster create ${KUBE_CLUSTER_NAME} --agents $KUBE_NUM_AGENTS -p 80:80@loadbalancer -p $NGINX_EXTERNAL_TLS_PORT:443@loadbalancer $KUBE_ARGS $KUBE_REGISTRY --k3s-arg "--disable=traefik@server:0"
      $KUBE_EXE cluster create ${KUBE_CLUSTER_NAME} --agents $KUBE_NUM_AGENTS -p 80:80@loadbalancer -p $NGINX_EXTERNAL_TLS_PORT:443@loadbalancer  $KUBE_ARGS $KUBE_REGISTRY --k3s-arg "--disable=traefik@server:0"
    elif [ "$KUBERNETES_TYPE" == "minikube" ]; then
      echo $KUBE_EXE start -p ${KUBE_CLUSTER_NAME} $KUBE_NUM_AGENTS $KUBE_ARGS $KUBE_REGISTRY --k3s-arg "--disable=traefik@server:0"
      #TODO: Needed to add full minikube settings (ports...)
      $KUBE_EXE start -p ${KUBE_CLUSTER_NAME}
    fi
  else
    if [ "$KUBERNETES_TYPE" == "k3d" ]; then
      echo $KUBE_EXE cluster create ${KUBE_CLUSTER_NAME} --agents $KUBE_NUM_AGENTS -p 80:80@loadbalancer -p $NGINX_EXTERNAL_TLS_PORT:443@loadbalancer $KUBE_ARGS --k3s-arg "--disable=traefik@server:0"
      $KUBE_EXE cluster create ${KUBE_CLUSTER_NAME} --agents $KUBE_NUM_AGENTS -p 80:80@loadbalancer -p $NGINX_EXTERNAL_TLS_PORT:443@loadbalancer  $KUBE_ARGS --k3s-arg "--disable=traefik@server:0"
    elif [ "$KUBERNETES_TYPE" == "minikube" ]; then
      echo $KUBE_EXE start -p ${KUBE_CLUSTER_NAME} $KUBE_NUM_AGENTS $KUBE_ARGS --k3s-arg "--disable=traefik@server:0"
      #TODO: Needed to add full minikube settings (ports...)
      $KUBE_EXE start -p ${KUBE_CLUSTER_NAME}
    fi
  fi

  sleep 3
  cluster_connection;
}

kube_delete_cluster() {
  if [ "$KUBERNETES_TYPE" == "k3d" ]; then
    $KUBE_EXE cluster delete $1
  elif [ "$KUBERNETES_TYPE" == "crc" ]; then
    $KUBE_EXE stop
    $KUBE_EXE delete
  else
    $KUBE_EXE stop -p $1
    $KUBE_EXE delete -p $1
  fi
}

create_local_cluster() {
  kube_init
  info_message "Checking if kubernetes provider is installed"

  if ! command_exists $KUBE_EXE; then
    info_message "Kubernetes provider isn't installed. Please, install it and re-run"
    exit 1

    #automate the crc installation

  else
    info_message "Kubernetes provider seems to be installed"
  fi

  info_message "Local registry management"

  create_registry;
  push_images_to_local_registry;

  info_message "Creating $KUBE_CLUSTER_NAME cluster"

  if check_cluster_exists; then
    info_message "Cluster $KUBE_CLUSTER_NAME already exists"
    cluster_connection;
  else
    create_cluster;
  fi
}

remove_services(){
  info_message "Removing existing services"
	if [[ $(helm ls -q -n $NAMESPACE) ]]; then 
	  for OUTPUT in $( helm ls -q -n mobius); do 
	    helm uninstall -n $NAMESPACE $OUTPUT;
        info_message "Waiting termination  $OUTPUT"
		sleep 30;		
	  done  
	fi
}

create_local_cluster_remove_existing() {
  kube_init
  info_message "Checking if kubernetes provider is installed"

  if ! command_exists $KUBE_EXE; then
    info_message "Kubernetes provider isn't installed. Please, install it and re-run"
    exit 1
  else
    info_message "Kubernetes provider seems to be installed"
  fi

  info_message "Local registry management"

  create_registry;
  push_images_to_local_registry;

  info_message "Creating $KUBE_CLUSTER_NAME cluster"
  if check_cluster_exists; then
    info_message "Cluster $KUBE_CLUSTER_NAME already exists"
	remove_services;
	info_message "Removing existing cluster"
	kube_delete_cluster "${KUBE_CLUSTER_NAME:-mobius}";
	info_message "Waiting termination"
	sleep 30;  
  fi  
  create_cluster;
  
}

start_cluster(){
  kube_init
  if check_cluster_exists; then
    info_message "Starting cluster $KUBE_CLUSTER_NAME"
	$KUBE_EXE cluster start $KUBE_CLUSTER_NAME 
  else
    info_message "Cluster $KUBE_CLUSTER_NAME does not exists. Please create cluster $KUBE_CLUSTER_NAME"
    exit 1	
  fi
}

stop_cluster(){
  kube_init
  if check_cluster_exists; then
    info_message "Stopping cluster $KUBE_CLUSTER_NAME"
	$KUBE_EXE cluster stop $KUBE_CLUSTER_NAME 
  else
    info_message "Cluster $KUBE_CLUSTER_NAME does not exists."
    exit 1	
  fi
}

debug_cluster(){
    log_dir="logs"

    if [ ! -d "$log_dir" ]; then
       mkdir -p "$log_dir"
    else
       rm $log_dir/*.*
    fi

    namespace_list=( $NAMESPACE )

    for namespace in "${namespace_list[@]}"
        do
            echo "Namespace: $namespace"

            pods=$(kubectl -n $namespace get pods --output=name)

            for pod in $pods
                do
                pod_name=$(echo $pod | cut -d/ -f2) 
                kubectl -n $namespace get pod/$pod_name -o yaml > $log_dir/${namespace}_${pod_name}_POD_GET.yaml 
                kubectl -n $namespace describe pod/$pod_name    > $log_dir/${namespace}_${pod_name}_POD_DESCRIBE.txt
                kubectl -n $namespace logs pod/$pod_name        > $log_dir/${namespace}_${pod_name}_POD_LOG.txt

                done

            services=$(kubectl -n $namespace get services --output=name)

            for srv in $services
                do
                srv_name=$(echo $srv | cut -d/ -f2) 

                kubectl -n $namespace get service/$srv_name -o yaml > $log_dir/${namespace}_${srv_name}_SERVICE_GET.yaml 
                kubectl -n $namespace describe service/$srv_name    > $log_dir/${namespace}_${srv_name}_SERVICE_DESCRIBE.txt

                done

            ingresses=$(kubectl -n $namespace get ingress --output=name)

            for ingress in $ingresses
                do
                ingress_name=$(echo $ingress | cut -d/ -f2) 

                kubectl -n $namespace get ingress/$ingress_name -o yaml > $log_dir/${namespace}_${ingress_name}_INGRESS_GET.yaml 
                kubectl -n $namespace describe ingress/$ingress_name    > $log_dir/${namespace}_${ingress_name}_INGRESS_DESCRIBE.txt

                done

            secrets=$(kubectl -n $namespace get secret --output=name)

            for secret in $secrets
                do
                secret_name=$(echo $secret | cut -d/ -f2) 

                if [[ ! "$secret_name" == *".helm."* ]]; then
                    kubectl -n $namespace get secret/$secret_name -o yaml > $log_dir/${namespace}_${secret_name}_SECRET_GET.yaml 
                    #kubectl -n $namespace describe secret/$secret_name    > $log_dir/${namespace}_${secret_name}_DESCRIBE_SECRET.txt
                fi
                done

            echo "Debug files in ./$log_dir"
        done
}