#!/bin/bash

source ./env.sh

log_dir="logs"

if [ ! -d "$log_dir" ]; then
  mkdir -p "$log_dir"
else
  rm $log_dir/*.*
fi

namespace_list=(${TF_VAR_NAMESPACE} ${TF_VAR_NAMESPACE_SHARED})
# namespace_list=( ${TF_VAR_NAMESPACE} )

for namespace in "${namespace_list[@]}"
    do
        echo "Namespace: $namespace"

        pods=$(kubectl -n $namespace get pods --output=name)

        for pod in $pods
            do
            pod_name=$(echo $pod | cut -d/ -f2) 
            kubectl -n $namespace get pod/$pod_name -o yaml > $log_dir/${namespace}_${pod_name}_POD_GET.yaml 
            kubectl -n $namespace describe pod/$pod_name    > $log_dir/${namespace}_${pod_name}_POD_DESCRIBE.txt

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
