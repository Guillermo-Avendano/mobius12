#!/bin/bash

helm_login() {
    if [ "$ZENITH_REGISTRY_TYPE" == "private" ]; then

      if [ "$ZENITH_KUBERNETES_TYPE" != "eks" ]; then
        AWS_ACCESS_KEY_ID=$ZENITH_AWS_ACCESS_KEY;
        AWS_SECRET_ACCESS_KEY=$ZENITH_AWS_SECRET_KEY;
        AWS_DEFAULT_REGION=us-east-1;
        export AWS_ACCESS_KEY_ID=$ZENITH_AWS_ACCESS_KEY;
        export AWS_SECRET_ACCESS_KEY=$ZENITH_AWS_SECRET_KEY;
        export AWS_DEFAULT_REGION=us-east-1;
      fi
      
      aws ecr get-login-password --region us-east-1 | helm registry login --username AWS --password-stdin $ZENITH_REGISTRY;
    fi

    if [ "$ZENITH_REGISTRY_TYPE" == "public" ]; then
        helm registry login --username $registry_username --password $registry_password $ZENITH_REGISTRY;
    fi
}

helm_logout() {
    if [ "$ZENITH_REGISTRY_TYPE" == "private" ]; then
        helm registry logout $ZENITH_REGISTRY;
        unset AWS_ACCESS_KEY_ID;
        unset AWS_SECRET_ACCESS_KEY;
        unset AWS_DEFAULT_REGION;
    fi

    if [ "$ZENITH_REGISTRY_TYPE" == "public" ]; then
        helm registry logout $ZENITH_REGISTRY;
    fi
}

helm_chart_automation_next_name() {
    echo "oci://$ZENITH_REGISTRY/chart/automation-next"
}

helm_chart_zenith_name() {
    echo "oci://$ZENITH_REGISTRY/chart/zenith"
}

helm_chart_oracle_name() {
    echo "oci://$ZENITH_REGISTRY/chart/oracle-db"
}

helm_chart_jvmainframe_name() {
    echo "oci://$ZENITH_REGISTRY/chart/jvmainframe"
}

is_release_exist() {

  local release_name;
  local current_namespace;

  if [ $# -ge 1 ]; then
    args=("$@");
    release_name=${args[0]};
    current_namespace=${args[1]};
  fi

  local release_exist=false;

  while read line; do

  case $line in
    *"$release_name"*) release_exist=true;;
  esac

  done < <(echo "$(helm list -n $current_namespace -o yaml 2> /dev/null)")

  if [ "$release_exist" == true ] ; then

    echo true;

  else

    echo false;

  fi

}

