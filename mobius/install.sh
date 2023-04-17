#!/bin/bash

source ../env.sh
source ../common/common.sh

if [ ! -d "cert" ]; then
  mkdir -p "cert"
fi

if ! [ -e "cert/$TF_VAR_MOBIUS_VIEW_URL.key" ] && ! [ -e "cert/$TF_VAR_MOBIUS_VIEW_URL.crt" ]; then

  highlight_message "Generating certificates: cert/$TF_VAR_MOBIUS_VIEW_URL.key and cert/$TF_VAR_MOBIUS_VIEW_URL.crt"

  openssl req -x509 -newkey rsa:2048 -sha256 -days 3650 -nodes -keyout "cert/$TF_VAR_MOBIUS_VIEW_URL.key" -out "cert/$TF_VAR_MOBIUS_VIEW_URL.crt" -subj "/CN=$TF_VAR_MOBIUS_VIEW_URL/O=$TF_VAR_MOBIUS_VIEW_URL" -addext "subjectAltName=DNS:$TF_VAR_MOBIUS_VIEW_URL" -addext 'extendedKeyUsage=serverAuth,clientAuth'

fi

terraform apply

pod_name="view"

pod=$(kubectl -n $TF_VAR_NAMESPACE get pods --output=name | grep "$pod_name")

if kubectl -n $TF_VAR_NAMESPACE get pods --output=name | grep "$pod_name"; then
    kubectl -n $TF_VAR_NAMESPACE delete "$pod"
fi

highlight_message "kubectl -n $TF_VAR_NAMESPACE get pods"
kubectl -n $TF_VAR_NAMESPACE get pods

highlight_message "kubectl -n $TF_VAR_NAMESPACE get ingress"
kubectl -n $TF_VAR_NAMESPACE get ingress


