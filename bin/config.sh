kubectl create secret docker-registry my-registry-secret \
--docker-server=example.com:5000 \
--docker-username=user \
--docker-password=passw0rd \
--docker-email=my-email@example.com


k3d cluster create -c config.yaml

