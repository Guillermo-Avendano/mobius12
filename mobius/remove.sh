#!/bin/bash

terraform destroy

kubectl delete namespace $TF_VAR_NAMESPACE_SHARED

