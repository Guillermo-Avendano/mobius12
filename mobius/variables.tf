variable "kube_config" {
  type    = string
  default = "~/.kube/config"
}

variable "namespace" {
  type    = string
  default = "mobius-sales"
}

variable "mobius" {
  type = list(object({
    RDSPROVIDER=string
    # secret key endpoint
    RDSENDPOINT=string
    RDSPORT= number
    RDSPROTO= string
    # secret key user
    MOBIUSUSERNAME= string
    # secret key schema
    MOBIUSSCHEMANAME= string
    # secret key password
    MOBIUSSCHEMAPASSWORD= string
    # secret key topicUrl
    TOPIC_EXPORT_URL = string
    # secret key topicUser
    TOPIC_EXPORT_USER = string
    # secret key topicPassword
    TOPIC_EXPORT_PASSWORD = string
    TOPIC_EXPORT_DRIVER=string    
    DEFAULT_SSO_KEY= string
    ENABLEINDEX= string
    MOBIUS_FTS_ENGINE_TYPE= string
    MOBIUS_FTS_SERVER_PROTOCOL= string
    MOBIUS_FTS_HOST=string
    MOBIUS_FTS_PORT= number
    MOBIUS_FTS_INDEX_NAME= string
    MOBIUS_ADMIN_USER= string
    MOBIUS_ADMIN_GROUP= string
  }))
  default = [
    {
      RDSPROVIDER="POSTGRESQL"
      RDSENDPOINT="postgres-postgresql.shared"
      RDSPORT= 5432
      RDSPROTO= "TCP"
      MOBIUSUSERNAME= "mobiusserver12"
      MOBIUSSCHEMANAME= "mobiusserver12"
      MOBIUSSCHEMAPASSWORD= "postgres"
      TOPIC_EXPORT_URL="jdbc:postgresql://${RDSENDPOINT}:${RDSPORT}/eventanalytics"
      TOPIC_EXPORT_USER="eventanalytics"
      TOPIC_EXPORT_PASSWORD="postgres"
      TOPIC_EXPORT_DRIVER="org.postgresql.Driver"
      DEFAULT_SSO_KEY= "ADASDFASDFXGGEG25585"
      ENABLEINDEX= "YES"
      MOBIUS_FTS_ENGINE_TYPE= "elasticsearch"
      MOBIUS_FTS_SERVER_PROTOCOL= "HTTP"
      MOBIUS_FTS_HOST= "elasticsearch-master.shared"
      MOBIUS_FTS_PORT= 9200
      MOBIUS_FTS_INDEX_NAME= "mobius12"
      MOBIUS_ADMIN_USER= "admin"
      MOBIUS_ADMIN_GROUP= "mobiusadmin"
    }
  ]
}


variable "mobius-kube" {
  type = list(object({
    image_repository=string
    image_tag=string
    storageClassName= string
    persistentVolume_volumeName= string
    persistentVolume_claimName= string
    persistentVolume_size= string
    mobiusDiagnostics_persistentVolume_volumeName= string
    mobiusDiagnostics_persistentVolume_claimName= string
    mobiusDiagnostics_persistentVolume_size= string

  }))
  default = [
    {
    image_repository="registry.asg.com/mobius-server"
    image_tag= "12.0.0"
    storageClassName= "microk8s-hostpath"
    persistentVolume_volumeName= "pv-mobius12-efs"
    persistentVolume_claimName= "pvc-mobius12-efs"
    persistentVolume_size= "1Gi"
    mobiusDiagnostics_persistentVolume_volumeName= "pv-mobius12-diagnose"
    mobiusDiagnostics_persistentVolume_claimName= "pvc-mobius12-diagnose"
    mobiusDiagnostics_persistentVolume_size= "1Gi"
    }
  ]
}