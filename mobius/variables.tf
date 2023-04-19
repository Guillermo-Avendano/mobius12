# The content is replaced by the env variable TF_VAR_NAMESPACE in ./common/env.sh if exists
variable "NAMESPACE" {
  type    = string
  default = "mobius"
}
variable "kube_config" {
  type    = string
  default = "../cluster/cluster-config.yaml"
}

variable "KUBE_LOCALREGISTRY_HOST" {
  type    = string
  default = "localhost"
}

variable "KUBE_LOCALREGISTRY_PORT" {
  type    = string
  default = "5000"
}

variable "IMAGE_VERSION_MOBIUS" {
  type    = string
  default = "12.1.004"
}

variable "IMAGE_VERSION_MOBIUSVIEW" {
  type    = string
  default = "12.1.1"
}
variable "IMAGE_VERSION_EVENTANALYTICS" {
  type    = string
  default = "1.3.8"
}
variable "POSTGRESQL_USERNAME" {
  type    = string
  default = "mobius"
}

variable "POSTGRESQL_PASSWORD" {
  type    = string
  default = "password"
}


variable "POSTGRESQL_DBNAME_MOBIUSVIEW" {
  type    = string
  default = "mobiusview12"
}

variable "POSTGRESQL_DBNAME_MOBIUS" {
  type    = string
  default = "mobiusserver12"
}

variable "POSTGRESQL_DBNAME_EVENTANALYTICS" {
  type    = string
  default = "eventanalytics"
}

variable "RDSENDPOINT" {
  type    = string
  default = "postgresql.shared.svc.cluster.local"
}

variable "RDSPORT" {
  type    = string
  default = "5432"
}

variable "mobius" {
  type = map(string)
  default = {
      RDSPROVIDER                = "POSTGRESQL"
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
      storageClassName                              = "manual"
      persistentVolume_claimName                    = "pvc-mobius12-efs"
      mobiusDiagnostics_persistentVolume_claimName  = "pvc-mobius12-diagnose"
    }

}

variable "MOBIUS_LICENSE" {
  type    = string
  default = "license"
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
      # mobius service
      MOBIUS_HOST                = "mobius12"
      MOBIUS_PORT                = "8080"
    }
}

variable "mobiusview-kube" {
  type = map(string)
  default = {
      master_persistence_claimName                             = "pvc-mobiusview12-storage"
      master_mobiusViewDiagnostics_persistentVolume_claimName  = "pvc-mobiusview12-diagnostics"
      master_presentations_persistentVolume_claimName          = "pvc-mobiusview12-presentation"

      datasource_databaseConnectivitySecretName                = "mobiusview-server-secrets"
      datasource_databaseUrlSecretValue                        = "url"
      datasource_databaseUsernameSecretValue                   = "username"
      datasource_databasePasswordSecretValue                   = "password"
      service_port                                             = "8080"
    }
}