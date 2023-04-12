#!/bin/bash

source ../common/env.sh
source ../common/common.sh

if ! [ -e ../cert/$TF_VAR_MOBIUS_VIEW_URL.key ] && ! [ -e ../cert/$TF_VAR_MOBIUS_VIEW_URL.crt]; then
  info_message "Generating certificates: ../cert/$TF_VAR_MOBIUS_VIEW_URL.key and ../cert/$TF_VAR_MOBIUS_VIEW_URL.crt"
  openssl req -x509 -newkey rsa:2048 -sha256 -days 3650 -nodes -keyout "../cert/${$TF_VAR_MOBIUS_VIEW_URL}.key" -out "../cert/${$TF_VAR_MOBIUS_VIEW_URL}.crt" -subj "/CN=${$TF_VAR_MOBIUS_VIEW_URL}" -addext "subjectAltName=DNS:${$TF_VAR_MOBIUS_VIEW_URL}" -addext 'extendedKeyUsage=serverAuth,clientAuth'

fi

kubectl create namespace $TF_VAR_NAMESPACE

kubectl apply -f pvc-mobiusview.yaml -n $TF_VAR_NAMESPACE

terraform apply
