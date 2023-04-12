#!/bin/bash

kube_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
[ -d "$kube_dir" ] || {
    echo "FATAL: no current dir (maybe running in zsh?)"
    exit 1
}

source "$kube_dir/common/env.sh"
source "$kube_dir/common/common.sh"
source "$kube_dir/common/cluster.sh"
source "$kube_dir/common/kubernetes.sh"
source "$kube_dir/common/local_registry.sh"

# Getting Images
# "$kube_dir/common/local_registry.sh"
push_images_to_local_registry;




