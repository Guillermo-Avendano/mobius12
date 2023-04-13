# The content is replaced by the env variable TF_VAR_NAMESPACE in ./common/env.sh if exists
variable "NAMESPACE" {
  type    = string
  default = "mobius"
}
variable "kube_config" {
  type    = string
  default = "~/.kube/config"
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
      MOBIUS_LOCALREGISTRY_HOST                     = "localhost"
      MOBIUS_LOCALREGISTRY_PORT                     = "5000"
      EVENTANALYTICS_VERSION                        = "1.3.8"
      MOBIUS_SERVER_VERSION                         = "12.1.0004"
      MOBIUS_VIEW_VERSION                           = "12.1.1"
    }

}

variable "MOBIUS_VIEW_URL" {
  type    = string
  default = "mobius12.local.net"
}

variable "MOBIUS_VIEW_TLS_SECRET" {
  type    = string
  default = "mobius-tls-secret"
}

variable "mobiusview" {
  type = map(string)
  default = {
      MOBIUS_LICENSE             = "01MOBIUS52464A464C4BC95859518381908FAEA4434F46515E53539681955B454D6240534556564351471D454D12405303565672514759454D1640530556560B51470E454D6040537C56560D514715454D1040536556560351470A454D0540531356560951472A454D2A40531556561D5642BB544F4A095454A4A7A744454B0C4A4FB2A2A0365456594348D9B486"
      SPRING_DATASOURCE_URL      = "jdbc:postgresql://postgres-postgresql.shared:5432/mobiusview12"
      SPRING_DATASOURCE_USERNAME = "mobiusview12"
      SPRING_DATASOURCE_PASSWORD = "postgres"
      # mobius service
      MOBIUS_HOST                = "mobius12"
      MOBIUS_PORT                = "8080"
    }
}

variable "mobiusview-kube" {
  type = map(string)
  default = {
      image_repository                                         = "registry.asg.com/mobius-view"
      image_tag                                                = "12.1.0"

      master_persistence_claimName                             = "pvc-mobiusview12-storage"
      master_persistence_accessMode                            = "ReadWriteOnce"
      master_persistence_size                                  = "1Gi"

      master_mobiusViewDiagnostics_persistentVolume_claimName  = "pvc-mobiusview12-diagnostics"
      master_mobiusViewDiagnostics_persistentVolume_accessMode = "ReadWriteOnce"
      master_mobiusViewDiagnostics_persistentVolume_size       = "1Gi"

      master_presentations_persistentVolume_claimName          = "pvc-mobiusview12-presentation"
      master_presentations_persistentVolume_accessMode         = "ReadWriteOnce"
      master_presentations_persistentVolume_size               = "1Gi"

      datasource_databaseConnectivitySecretName                = "mobiusview-server-secrets"
      datasource_databaseUrlSecretValue                        = "url"
      datasource_databaseUsernameSecretValue                   = "username"
      datasource_databasePasswordSecretValue                   = "password"

      service_port                                             = "8080"
    }
}