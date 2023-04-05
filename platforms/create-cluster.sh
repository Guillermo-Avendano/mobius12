
k3d cluster create mobius -p "8900:30080@agent:0" -p "8901:30081@agent:0" -p "8902:30082@agent:0" --agents 2

# Deploy Ranger cluster
helm repo add rancher-latest https://releases.rancher.com/server-charts/latest

helm install rancher rancher-latest/rancher --namespace cattle-system --create-namespace --set ingress.enabled=false --set tls=external --set replicas=1

kubectl apply -f rancher.yaml