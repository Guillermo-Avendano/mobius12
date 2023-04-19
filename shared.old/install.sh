#!/bin/bash

source ../env.sh
source ../common/common.sh

terraform apply

highlight_message "kubectl -n $TF_VAR_NAMESPACE_SHARED get pods"
kubectl -n $TF_VAR_NAMESPACE_SHARED get pods

highlight_message "kubectl -n $TF_VAR_NAMESPACE_SHARED get ingress"
kubectl -n $TF_VAR_NAMESPACE_SHARED get ingress