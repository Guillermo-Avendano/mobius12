#!/bin/bash

source ../common/env.sh
source ../common/common.sh

pod_name="view"

pod=$(kubectl -n $TF_VAR_NAMESPACE get pods --output=name | grep "$pod_name")

if kubectl -n $TF_VAR_NAMESPACE get pods --output=name | grep "$pod_name"; then
    kubectl -n $TF_VAR_NAMESPACE delete "$pod"
fi
