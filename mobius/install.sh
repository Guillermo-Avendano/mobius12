#!/bin/bash

source ../common/env.sh
source ../common/common.sh

if ! [ -e "cert/$TF_VAR_MOBIUS_VIEW_URL.key" ] && ! [ -e "cert/$TF_VAR_MOBIUS_VIEW_URL.crt" ]; then
  info_message "Generating certificates: cert/$TF_VAR_MOBIUS_VIEW_URL.key and cert/$TF_VAR_MOBIUS_VIEW_URL.crt"
  openssl req -x509 -newkey rsa:2048 -sha256 -days 3650 -nodes -keyout "cert/${TF_VAR_MOBIUS_VIEW_URL}.key" -out "cert/${TF_VAR_MOBIUS_VIEW_URL}.crt" -subj "/CN=${TF_VAR_MOBIUS_VIEW_URL}" -addext "subjectAltName=DNS:${TF_VAR_MOBIUS_VIEW_URL}" -addext 'extendedKeyUsage=serverAuth,clientAuth'
fi

kubectl create namespace $TF_VAR_NAMESPACE

kubectl apply -f pvc/pvc-mobiusview.yaml -n $TF_VAR_NAMESPACE

terraform apply

set pod_name=view

for /f "delims=" %%i in ('kubectl -n $TF_VAR_NAMESPACE get pods --output=name ^| findstr /C:"%pod_name%"') do (
    echo Pod encontrado: %%i
    kubectl -n $TF_VAR_NAMESPACE delete "%%i"
)

highlight_message "kubectl -n $TF_VAR_NAMESPACE get pods";
kubectl -n $TF_VAR_NAMESPACE get pods

highlight_message "kubectl -n $TF_VAR_NAMESPACE get pods";
kubectl -n $TF_VAR_NAMESPACE get ingress


