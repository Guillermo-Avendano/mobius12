# Default values for eventanalytics.
# This is a YAML-formatted file.
# Declare variables to be passed into your templates.

#replicaCount is the number of replicas required for this service
replicaCount: 1
namespace: <NAMESPACE>



image:
  #repository is the docker registory to pull docker images
  repository: k3d-<NAME_LOCALREGISTRY>:<PORT_LOCALREGISTRY>/<IMAGE_NAME_EVENTANALYTICS>
  #tag is the docker image tag(it may be latest or any version)
  tag:  <IMAGE_VERSION_EVENTANALYTICS>
  #pullPolicy is the policy to pull images
  pullPolicy: IfNotPresent
  
service:
  type: ClusterIP


datasource:
  #url is the db endpoint with port number and schema name where the database connectivity will be established
  url: jdbc:postgresql://<POSTGRESQL_HOST>:<POSTGRESQL_PORT>/<POSTGRESQL_DBNAME_EVENTANALYTICS>
  #username is the admin account for the Database, used when creating new DB schemas
  username: <POSTGRESQL_USERNAME>
  #password is the admin account password for the Database, used when creating new DB schemas
  password: <POSTGRESQL_PASSWORD>
  #driverClassName is the database drive class name
  driverClassName: org.postgresql.Driver
  hikari:
    autoCommit: false

asg:
  eventanalytics:
    kafka:
      topic: "audit"
      groupid: "event-analytics-group"
       
#      keystore:
#        secretName: eventanalytics-keystore-secret
#        name: eventanalytics.keystore.p12
       
#      truststore:
#        secretName: eventanalytics-truststore-secret
#        certificateName: RootCA.crt

spring:
  kafka: 
    security:
      protocol: PLAINTEXT
    bootstrap:
      servers: <KAFKA_BOOTSTRAP_URL>
    consumer:
      auto:
        offset:
          reset: earliest
		  
{{file("eventanalytics.yaml") | indent(2)}}		  