#!/bin/bash

source ../common/env.sh

kubectl create namespace $TF_VAR_NAMESPACE

kubectl apply -f pvc-mobiusview.yaml -n $TF_VAR_NAMESPACE

terraform apply
