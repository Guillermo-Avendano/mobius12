# This is a YAML-formatted file.
# Declare variables to be passed into your templates.

#replicaCount is the number of replicas required for this service
replicaCount: 1
#namespace is the place for the service to run
namespace: ${NAMESPACE}
image:
  # Placeholders will replaced in runtime based on .env file
  repository: ${KUBE_LOCALREGISTRY_HOST}:${KUBE_LOCALREGISTRY_PORT}/${IMAGE_NAME_MOBIUS}
  tag: ${IMAGE_VERSION_MOBIUS}
  pullPolicy: IfNotPresent
mobius:
  admin:
    #Adding a group to the document server to be accessed from. Accepts comma separated values
    group: "${MOBIUS_ADMIN_GROUP}"
    user: "${MOBIUS_ADMIN_USER}"
  rds:
    #provider is the DBMS System being used. "ORACLE" or "POSTGRESQL".
    provider: "POSTGRESQL"
    #endpoint is the hostname of the RDS Database
    endpoint: "${POSTGRESQL_HOST}"
    #port is the port used by the Database
    port: "${POSTGRESQL_PORT}"
    #credentials
    # Placeholders will replaced in runtime based on .env file
    user: "${POSTGRESQL_USERNAME}"
    password: "${POSTGRESQL_PASSWORD}"
    schema: "${POSTGRESQL_DBNAME_MOBIUS}"
  persistentVolume:
    enabled: true
    claimName: ${mobius_persistentVolume_claimName}
  mobiusDiagnostics:
    persistentVolume:
      #enabled is the flag to indicate whether persistence claim for mobius diagnostics report is required or not
      #By setting the value as false, application logs will be lost when the pod is removed
      enabled: true
      # persistent volume claim name for mobius diagnostics report
      claimName: ${mobius_mobiusDiagnostics_persistentVolume_claimName}
  createDocumentServer: "YES"
  isSaas: "YES"
  sharedFileTemplate: "/mnt/efs"
  fts:
      #enabled set to yes to turn on full text search
      enabled: "YES"
      
      persistentVolume:
        enabled: true
        claimName: "mobius-fts-pv-claim"

      #Uncomment to enable elasticsearch for FTS      
      engineType: "elasticsearch"
      serverProtocol: "HTTP"
      host: ${MOBIUS_FTS_HOST}
      port: ${MOBIUS_FTS_PORT}
      indexName: ${MOBIUS_FTS_INDEX_NAME}

            
  #Uncomment to enable topic export to eventanalytics
  
  topic:
    export:
      url: jdbc:postgresql://${POSTGRESQL_HOST}:${POSTGRESQL_PORT}/${POSTGRESQL_DBNAME_EVENTANALYTICS}
      user: ${POSTGRESQL_USERNAME}
      password: ${POSTGRESQL_PASSWORD}
      driver: org.postgresql.Driver

service:
  type: ClusterIP

#{{file("mobiusserver.yaml") | indent(2)}}
