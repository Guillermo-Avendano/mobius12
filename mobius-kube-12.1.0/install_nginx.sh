#!/bin/bash
set -Eeuo pipefail

install_nginx() {
      
    
	create_kubernetes_namespace $NGINX_NAMESPACE;
	
	info_message "Configuring nginx $NGINX_VERSION resources";
				
    cp $kube_dir/nginx/templates/$NGINX_CONF_FILE $kube_dir/nginx/$NGINX_CONF_FILE;
    replace_tag_in_file $kube_dir/nginx/$NGINX_CONF_FILE "<NGINX_VERSION>" $NGINX_VERSION; 
	replace_tag_in_file $kube_dir/nginx/$NGINX_CONF_FILE "<NAMESPACE>" $NAMESPACE;
	
	cp $kube_dir/nginx/templates/$NGINX_CUSTOM_SET_HEADER_FILE $kube_dir/nginx/$NGINX_CUSTOM_SET_HEADER_FILE;
    replace_tag_in_file $kube_dir/nginx/$NGINX_CUSTOM_SET_HEADER_FILE "<NGINX_NAMESPACE>" $NGINX_NAMESPACE;

    cp $kube_dir/nginx/templates/$NGINX_CUSTOM_ADD_HEADER_FILE $kube_dir/nginx/$NGINX_CUSTOM_ADD_HEADER_FILE;
    replace_tag_in_file $kube_dir/nginx/$NGINX_CUSTOM_ADD_HEADER_FILE "<NGINX_NAMESPACE>" $NGINX_NAMESPACE;
	
	cp $kube_dir/nginx/templates/$NGINX_CUSTOM_CONF_FILE $kube_dir/nginx/$NGINX_CUSTOM_CONF_FILE;
    replace_tag_in_file $kube_dir/nginx/$NGINX_CUSTOM_CONF_FILE "<NGINX_NAMESPACE>" $NGINX_NAMESPACE;
	
	cp $kube_dir/nginx/templates/$NGINX_INGRESS_FILE $kube_dir/nginx/$NGINX_INGRESS_FILE;
	replace_tag_in_file $kube_dir/nginx/$NGINX_INGRESS_FILE "<NAMESPACE>" $NAMESPACE;
    replace_tag_in_file $kube_dir/nginx/$NGINX_INGRESS_FILE "<HOSTNAME>" $HOSTNAME;
	
	helm repo add ingress-nginx  https://kubernetes.github.io/ingress-nginx
	helm repo update
	
	
	CERT_NAME=nginx-cert
    CERT_FILE=$kube_dir/nginx/nginx.cert
    KEY_FILE=$kube_dir/nginx/nginx.key
    
	
		
    exists=$(check_if_kubernetes_resource_exists secret ${CERT_NAME} $NAMESPACE);

    if [ "$exists" == "true" ]; then
        info_message "Using existing secret for certificates"
    else
	  if [[ ! -f "${CERT_FILE}" && ! -f "${KEY_FILE}" ]] ; then
	    info_message "Creating self signed certificate";
	    openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ${KEY_FILE} -out ${CERT_FILE} -subj "/CN=$HOSTNAME/O=$HOSTNAME" -addext "subjectAltName = DNS:$HOSTNAME";
      else
        info_message "Using existing certificates for secret";
      fi
	  
  	  info_message "Creating secret";
	  $KUBE_CLI_EXE create secret tls ${CERT_NAME} --key ${KEY_FILE} --cert ${CERT_FILE} -n $NAMESPACE
	  
    fi
	
	
	info_message "Installing nginx $NGINX_VERSION";
    helm upgrade nginx ingress-nginx/ingress-nginx -f $kube_dir/nginx/$NGINX_CONF_FILE -n $NGINX_NAMESPACE --install
	
	info_message "Waiting for nginx to be ready";
    sleep 30
	
	info_message "Applying custom configuration"
	$KUBE_CLI_EXE apply -f  $kube_dir/nginx/$NGINX_CUSTOM_ADD_HEADER_FILE --namespace $NGINX_NAMESPACE
	$KUBE_CLI_EXE apply -f  $kube_dir/nginx/$NGINX_CUSTOM_SET_HEADER_FILE --namespace $NGINX_NAMESPACE
	$KUBE_CLI_EXE apply -f  $kube_dir/nginx/$NGINX_CUSTOM_CONF_FILE --namespace $NGINX_NAMESPACE
	
	sleep 30
	
	info_message "Configuring nginx rules"
	$KUBE_CLI_EXE apply -f  $kube_dir/nginx/$NGINX_INGRESS_FILE --namespace $NAMESPACE
	
	#info_message "Clean up resources";
    rm -f $kube_dir/nginx/$NGINX_CONF_FILE
	rm -f $kube_dir/nginx/$NGINX_CUSTOM_CONF_FILE
	rm -f $kube_dir/nginx/$NGINX_CUSTOM_ADD_HEADER_FILE
	rm -f $kube_dir/nginx/$NGINX_CUSTOM_SET_HEADER_FILE
    rm -f $kube_dir/nginx/$NGINX_INGRESS_FILE

    sleep 10

    #Uncomment if k3d portforwaring doesn't work and make NGINX a nodeport service. 
	#info_message "Forward a local port to the TLS port of ingress controller"
	#$KUBE_CLI_EXE port-forward --address 0.0.0.0 --namespace=$NGINX_NAMESPACE service/nginx-ingress-nginx-controller $NGINX_EXTERNAL_TLS_PORT:443 >/dev/null 2>&1 &
}


wait_for_nginx_ready() {
    info_message "Waiting for nginx to be ready";
    COUNTER=0
	output=`kubectl get pods -n $NGINX_NAMESPACE -o go-template --template '{{range .items}}{{if eq (.status.phase) ("Running")}}{{.metadata.name}}{{"\n"}}{{end}}{{end}}'`
    until [[ "$output" == *nginx* ]]
    do
        info_progress "...";
		let COUNTER=COUNTER+5
		if [[ "$COUNTER" -gt 300 ]]; then
		  echo "FATAL: Failed to install nginx. Please check logs and configuration"
          exit 1    
		fi
        sleep 5;
		output=`kubectl get pods -n $NGINX_NAMESPACE -o go-template --template '{{range .items}}{{if eq (.status.phase) ("Running")}}{{.metadata.name}}{{"\n"}}{{end}}{{end}}'`
    done
}


xargsflag="-d"
export $(grep -v '^#' .env | xargs ${xargsflag} '\n')
kube_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
[ -d "$kube_dir" ] || {
    echo "FATAL: no current dir (maybe running in zsh?)"
    exit 1
}

source "$kube_dir/common/common.sh"
source "$kube_dir/common/local_kube.sh"
source "$kube_dir/common/kubernetes.sh"

kube_init;


NGINX_CONF_FILE=nginx.yaml;
NGINX_CUSTOM_ADD_HEADER_FILE=custom-add-headers.yaml;
NGINX_CUSTOM_SET_HEADER_FILE=custom-set-headers.yaml;
NGINX_CUSTOM_CONF_FILE=nginx-ingress-nginx-controller.yaml;
NGINX_VERSION="${NGINX_VERSION:-v1.4.0}";
NGINX_INGRESS_FILE=ingress.yaml;

install_nginx;
wait_for_nginx_ready;
