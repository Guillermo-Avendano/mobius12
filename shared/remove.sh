#!/bin/bash

source ../common/env.sh

terraform destroy

kubectl delete namespace $TF_VAR_NAMESPACE

