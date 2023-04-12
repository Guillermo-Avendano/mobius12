#!/bin/bash

terraform destroy

if kubectl get namespace $TF_VAR_NAMESPACE >/dev/null 2>&1; then
  kubectl delete namespace $TF_VAR_NAMESPACE
fi