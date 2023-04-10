variable "kube_config" {
  type    = string
  default = "~/.kube/config"
}

variable "namespace" {
  type    = string
  default = "mobius"
}

variable "mobius" {
  type = map(string)
  default = {
      RDSPROVIDER                = "POSTGRESQL"
      RDSENDPOINT                = "postgres-postgresql.shared"
      RDSPORT                    = "5432"
      RDSPROTO                   = "TCP"
      MOBIUSUSERNAME             = "mobiusserver12"
      MOBIUSSCHEMANAME           = "mobiusserver12"
      MOBIUSSCHEMAPASSWORD       = "postgres"
      TOPIC_EXPORT_URL           = "jdbc:postgresql://postgres-postgresql.shared:5432/eventanalytics"
      TOPIC_EXPORT_USER          = "eventanalytics"
      TOPIC_EXPORT_PASSWORD      = "postgres"
      TOPIC_EXPORT_DRIVER        = "org.postgresql.Driver"
      DEFAULT_SSO_KEY            = "ADASDFASDFXGGEG25585"
      ENABLEINDEX                = "YES"
      MOBIUS_FTS_ENGINE_TYPE     = "elasticsearch"
      MOBIUS_FTS_SERVER_PROTOCOL = "HTTP"
      MOBIUS_FTS_HOST            = "elasticsearch-master.shared"
      MOBIUS_FTS_PORT            = "9200"
      MOBIUS_FTS_INDEX_NAME      = "mobius12"
      MOBIUS_ADMIN_USER          = "admin"
      MOBIUS_ADMIN_GROUP         = "mobiusadmin"
    }

}

variable "mobius-kube" {
  type = map(string)
  default = {
      image_repository                              = "registry.asg.com/mobius-server"
      image_tag                                     = "12.1.0"
      storageClassName                              = "microk8s-hostpath"
      persistentVolume_volumeName                   = "pv-mobius12-efs"
      persistentVolume_claimName                    = "pvc-mobius12-efs"
      persistentVolume_size                         = "1Gi"
      mobiusDiagnostics_persistentVolume_volumeName = "pv-mobius12-diagnose"
      mobiusDiagnostics_persistentVolume_claimName  = "pvc-mobius12-diagnose"
      mobiusDiagnostics_persistentVolume_size       = "1Gi"
    }

}
