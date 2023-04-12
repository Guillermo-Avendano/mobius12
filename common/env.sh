KUBE_CLUSTER_NAME=mobius                            # mobius_infra.sh

# curl -X GET -u gavendano@rs.com:#### https://registry.rocketsoftware.com/v2/_catalog
# curl -X GET -u gavendano@rs.com:#### https://registry.rocketsoftware.com/v2/mobius-view/tags/list 


DOCKER_USER=gavendano@rs.com                        # common/local_registry.sh

DOCKER_PASS=Guillei30#                              # common/local_registry.sh

MOBIUS_SOURCE_REGISTRY=registry.rocketsoftware.com  # common/local_registry.sh 
MOBIUS_SERVER_VERSION=12.1.0004                     # common/local_registry.sh mobius/main.tf
MOBIUS_VIEW_VERSION=12.1.1                          # common/local_registry.sh mobius/main.tf  
EVENTANALYTICS_VERSION=1.3.8                        # common/local_registry.sh mobius/main.tf

MOBIUS_LOCALREGISTRY_NAME=mobius-registry           # common/local_registry.sh
MOBIUS_LOCALREGISTRY_HOST=$HOSTNAME                 # mobius/main.tf
MOBIUS_LOCALREGISTRY_PORT=5000                      # mobius/main.tf