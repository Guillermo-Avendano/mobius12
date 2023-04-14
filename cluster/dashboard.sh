#!/bin/bash

export KUBECONFIG=~/.kube/config

helm install kube-dashboard kubernetes-dashboard/ --namespace=kube-system --wait

kubectl create secret generic secret-admin-dashboard --from-literal=token=123456789 -n kube-system

kubectl patch serviceaccount admin-dashboard -p '{"imagePullSecrets": [{"name": "secret-admin-dashboard"}]}' -n kube-system



# kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep kubernetes-dashboard-key-holder  | awk '{print $1}')
