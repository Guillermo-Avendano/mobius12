#!/bin/bash

source ../env.sh

terraform destroy

if kubectl get namespace $TF_VAR_NAMESPACE_SHARED >/dev/null 2>&1; then
  kubectl delete namespace $TF_VAR_NAMESPACE_SHARED
fi