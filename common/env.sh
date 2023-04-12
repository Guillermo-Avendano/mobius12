KUBE_CLUSTER_NAME="mobius"                            # mobius_infra.sh

# curl -X GET -u gavendano@rs.com:#### https://registry.rocketsoftware.com/v2/_catalog
# curl -X GET -u gavendano@rs.com:#### https://registry.rocketsoftware.com/v2/mobius-view/tags/list 


DOCKER_USER="<user>@rs.com"                           # $HOME.profile
DOCKER_PASS="<pass>"                                  # $HOME/.profile

MOBIUS_SOURCE_REGISTRY="registry.rocketsoftware.com"  # common/local_registry.sh 
MOBIUS_SERVER_VERSION="12.1.0004"                     # common/local_registry.sh mobius/main.tf
MOBIUS_VIEW_VERSION="12.1.1"                          # common/local_registry.sh mobius/main.tf  
EVENTANALYTICS_VERSION="1.3.8"                        # common/local_registry.sh mobius/main.tf

MOBIUS_LOCALREGISTRY_NAME="registry.localhost"        # common/local_registry.sh
MOBIUS_LOCALREGISTRY_HOST="localhost"                 # common/local_registry.sh mobius/main.tf
MOBIUS_LOCALREGISTRY_PORT="5000"                      # common/local_registry.sh mobius/main.tf

TF_VAR_NAMESPACE="mobius-prod"                        # shared/variables.tf 
                                                      # mobius/variables.tf 
                                                      # mobius/install.sh
                                                      # remove.sh 
TF_VAR_NAMESPACE_SHARED="shared"                      # shared/variables.tf mobius/variables.tf