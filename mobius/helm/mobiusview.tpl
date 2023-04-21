# This is a YAML-formatted file.
# Declare variables to be passed into your templates.

#replicaCount is the number of replicas required for this service
replicaCount: 1
#namespace is the place for the service to run
namespace: ${NAMESPACE}
image:
  # Placeholders will replaced in runtime based on .env file
  repository: ${KUBE_LOCALREGISTRY_HOST}:${KUBE_LOCALREGISTRY_PORT}/${IMAGE_NAME_MOBIUSVIEW}
  tag: ${IMAGE_VERSION_MOBIUSVIEW}
  pullPolicy: IfNotPresent
deploy:
  fullstack: false
service:
  type: ClusterIP

datasource:
   url: "jdbc:postgresql://${POSTGRESQL_HOST}:${POSTGRESQL_PORT}/${POSTGRESQL_DBNAME_MOBIUSVIEW}"
   username: "${POSTGRESQL_USERNAME}"
   password: "${POSTGRESQL_PASSWORD}"

initRepository:
  enabled: true
  host: "${MOBIUS_HOST}"
  port: "${MOBIUS_PORT}"
  documentServer: "vdrnetds"
  defaultSSOKey: "ADASDFASDFXGGEG25585"
  logLevel: "ERROR"
  java:
    opts: ""
   
master:
  persistence:
   enabled: true
   claimName: ${master_persistence_claimName}
   accessMode: ReadWriteOne
   size: 1000M

  mobiusViewDiagnostics:
    persistentVolume:
      enabled: true
      claimName: ${master_mobiusViewDiagnostics_persistentVolume_claimName}
      accessMode: ReadWriteOne
      size: 1000M
      
  presentations:
    persistence:
      #enabled is the flag to indicate whether presentation persistence claim is required or not    
      enabled: true
      #claimName is the name of the claim created by the user, which will be bound to the mapped persistence volume
      claimName:  ${master_presentations_persistentVolume_claimName}
      

asg:
#Enable Kafka audit
  audit:
    topic: audit

spring:
 #Enable Kafka section to enable auditing to kafka. Configure the topic in audit.kafka section  
  kafka:
    bootstrap:
      servers: ${KAFKA_BOOTSTRAP_URL}
    security:
      protocol: PLAINTEXT
    producer:
      acks: all
      properties:
        enable:
          idempotence: true

  cloud:
    discovery:
      client:
        simple:
          instances:
            metrics:
              audit:
                uri: http://eventanalytics:8500  

ingress:
  enabled: true
  className: "nginx"
  annotations: 
    nginx.ingress.kubernetes.io/rewrite-target: /mobius$1
    nginx.ingress.kubernetes.io/proxy-body-size: "32m"
    nginx.ingress.kubernetes.io/affinity: "cookie"
    nginx.ingress.kubernetes.io/session-cookie-name: "session-cookie"
    nginx.ingress.kubernetes.io/session-cookie-expires: "172800"
    nginx.ingress.kubernetes.io/session-cookie-max-age: "172800"
    nginx.ingress.kubernetes.io/ssl-redirect: "false"
    nginx.ingress.kubernetes.io/affinity-mode: "persistent"
    nginx.ingress.kubernetes.io/session-cookie-change-on-failure: "false"
    nginx.ingress.kubernetes.io/session-cookie-hash: sha1
    nginx.ingress.kubernetes.io/session-cookie-path: /mobius
    nginx.ingress.kubernetes.io/proxy-buffer-size: "8k"
  hosts:
    - host: ${MOBIUS_VIEW_URL}
      paths:
        - path: /mobius(.*)$
          pathType: ImplementationSpecific

{{file("./mobiusview.yaml") | indent(2)}}	  				