#!/bin/bash

kube_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
[ -d "$kube_dir" ] || {
    echo "FATAL: no current dir (maybe running in zsh?)"
    exit 1
}

source "./env.sh"
source "$kube_dir/common/common.sh"
source "$kube_dir/cluster/cluster.sh"


wait_cluster;




