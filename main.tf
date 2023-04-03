###### Postgres

#-- define secret for postgres password
resource "kubernetes_secret" "postgres" {
  metadata {
    name = "postgres-secrets"
  }

  data = {
    postgres-password = "${base64encode("password")}"
  }
}

#-- deploy helm for postgres
resource "helm_release" "postgres" {
  name       = "postgres"
  chart      = "${path.module}/helm/shared-postgres"
  namespace  = var.namespace_shared
  create_namespace = true

  set {
    name  = "global.postgresql.auth.postgresPassword"
    value = "${kubernetes_secret.postgres.data["postgres-password"]}"
  }

  set {
    name  = "primary.initdb.scripts.create-databases\\.sql"
    value = "${file("mobius.sql")}"
   }
} 

###### Kafka deloyment
resource "helm_release" "kafka" {
  name       = "kafka"
  chart      = "${path.module}/helm/shared-kafka"
  namespace  = var.namespace_shared
  create_namespace = true

  set {
    name  = "image.repository"
    value = "bitnami/kafka"
  }

  set {
    name  = "image.tag"
    value = "3.3.2-debian-11-r22"
   }
   
   set {
    name  = "serviceAccount.name"
    value = "shared-kafka"
   }

}

###### Elasticsearch deloyment
resource "helm_release" "elastic" {
  name       = "elasticsearch"
  chart      = "${path.module}/helm/shared-elastic"
  namespace  = var.namespace_shared
  create_namespace = true

  set {
    name  = "image"
    value = "docker.elastic.co/elasticsearch/elasticsearch"
  }

  set {
    name  = "imageTag"
    value = "7.17.3"
   }

 # set {
 #   name  = "podSecurityPolicy.create"
 #   value = "true"
 #  }

 # set {
 #   name  = "persistence.enabled"
 #   value = "true"
 #  }

 
  set {
    name  = "ingress.hosts[0].host"
    value = "elastic.local.net"
   }

     values = [
    "${file("${path.module}/helm/shared-elastic/values.yaml")}"
  ]

}

###### Mobius 12
resource "kubernetes_persistent_volume" "mobius12-efs" {
  metadata {
    name = "pv-mobius12-efs"
    namespace  = var.namespace
  }
  spec {
    capacity = {
      storage = "1Gi"
    }
    access_modes = ["ReadWriteMany"]
  }
}
resource "kubernetes_persistent_volume_claim" "mobius12-efs" {
  metadata {
    name = "pvc-mobius12-efs"
    namespace  = var.namespace
  }
  spec {
    access_modes = ["ReadWriteMany"]
    resources {
      requests = {
        storage = "1Gi"
      }
    }
    volume_name = "${kubernetes_persistent_volume.mobius12-efs.metadata.0.name}"
  }
}

resource "kubernetes_persistent_volume" "mobius12-diag" {
  metadata {
    name = "pv-mobius12-diagnostics"
    namespace  = var.namespace
  }
  spec {
    capacity = {
      storage = "1Gi"
    }
    access_modes = ["ReadWriteMany"]
  }
}
resource "kubernetes_persistent_volume_claim" "mobius12-diag" {
  metadata {
    name = "pvc-mobius12-diagnostics"
    namespace  = var.namespace
  }
  spec {
    access_modes = ["ReadWriteMany"]
    resources {
      requests = {
        storage = "1Gi"
      }
    }
    volume_name = "${kubernetes_persistent_volume.mobius12-diag.metadata.0.name}"
  }
}

#-- define secret for postgres password
resource "kubernetes_secret" "mobius12" {
  metadata {
    name = "mobius-server-secrets"
    namespace  = var.namespace
  }

  data = {
    user = "${base64encode("mobiusserver12")}"
    schema = "${base64encode("mobiusserver12")}"
    password = "${base64encode("postgres")}"
    endpoint = "${base64encode("postgres-postgresql.shared")}"
    port = "${base64encode("5432")}"
    topicUrl = "${base64encode("jdbc:postgresql://postgres-postgresql.shared:5432/eventanalytics")}"
    topicUser = "${base64encode("eventanalytics")}"
    topicPassword = "${base64encode("postgres")}"
  }
}

resource "helm_release" "mobius12" {
  name       = "mobius12"
  chart      = "${path.module}/helm/mobius-12.0.0"
  namespace  = var.namespace
  create_namespace = true

  set {
    name  = "image.repository"
    value = "registry.asg.com/mobius-server"
  }

  set {
    name  = "image.tag"
    value = "12.0.0"
   }

   set {
    name = "storageClassName"
    value = "microk8s-hostpath"
   }

   set {
    name = "mobius.admin.user"
    value = "admin"
   }

   set {
    name = "mobius.admin.group"
    value = "mobiusadmin"
   }

   set {
    name = "mobius.fts.host"
    value = "elasticsearch-master.shared"
   }

   set {
    name = "mobius.persistentVolume.volumeName"
    value = "pv-mobius12-efs"
   }
   set {
    name = "mobius.persistentVolume.claimName"
    value = "pvc-mobius12-efs"
   }
  set {
    name = "mobius.persistentVolume.size"
    value = "1Gi"
   }

   set {
    name = "mobius.mobiusDiagnostics.persistentVolume.volumeName"
    value = "pv-mobius12-diagnostics"
   }
   set {
    name = "mobius.mobiusDiagnostics.persistentVolume.claimName"
    value = "pvc-mobius12-diagnostics"
   }
  set {
    name = "mobius.mobiusDiagnostics.persistentVolume.size"
    value = "1Gi"
   }
   set {
    name = "mobius.clustering.kubernetes.namespace"
    value = var.namespace
   }    
}