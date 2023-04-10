
resource "kubernetes_namespace" "mobius" {
  metadata {
    annotations = {
      name = var.namespace
    }

    labels = {
      mylabel = "mobius"
    }

    name = var.namespace
  }
}

resource "kubernetes_persistent_volume_claim" "mobius12-efs" {
  metadata {
    name = var.mobius-kube["persistentVolume_claimName"]
    namespace  = var.namespace
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "1Gi"
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim" "mobius12-diag" {
  metadata {
    name = var.mobius-kube["mobiusDiagnostics_persistentVolume_claimName"]
    namespace  = var.namespace
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "1Gi"
      }
    }
  }
}

resource "kubernetes_secret" "mobius12" {
  metadata {
    name = "mobius-server-secrets"
    namespace  = var.namespace
  }
  data = {
    user = var.mobius["MOBIUSUSERNAME"]
    schema = var.mobius["MOBIUSSCHEMANAME"]
    password = var.mobius["MOBIUSSCHEMAPASSWORD"]
    endpoint = var.mobius["RDSENDPOINT"]
    port = var.mobius["RDSPORT"]
    topicUrl = "jdbc:postgresql://${var.mobius["RDSENDPOINT"]}:${var.mobius["RDSPORT"]}/eventanalytics"
    topicUser = var.mobius["TOPIC_EXPORT_USER"]
    topicPassword = var.mobius["TOPIC_EXPORT_PASSWORD"]
  }
}

resource "helm_release" "mobius12" {
  name             = "mobius12"
  chart            = "${path.module}/helm/mobius-12.0.0"
  namespace        = var.namespace
  create_namespace = true

  set {
    name  = "image.repository"
    value = var.mobius-kube["image_repository"]
  }

  set {
    name  = "image.tag"
    value = var.mobius-kube["image_tag"]
  }

  set {
    name  = "storageClassName"
    value = var.mobius-kube["storageClassName"]
  }

  set {
    name  = "mobius.admin.user"
    value = var.mobius["MOBIUS_ADMIN_USER"]
  }

  set {
    name  = "mobius.admin.group"
    value = var.mobius["MOBIUS_ADMIN_GROUP"]
  }

  set {
    name  = "mobius.rds.provider"
    value = var.mobius["RDSPROVIDER"]
  }
  set {
    name  = "mobius.rds.protocol"
    value = var.mobius["RDSPORT"]
  }

  set {
    name  = "mobius.fts.host"
    value = var.mobius["MOBIUS_FTS_HOST"]
  }

  set {
    name  = "mobius.persistentVolume.volumeName"
    value = var.mobius-kube["persistentVolume_volumeName"]
  }
  set {
    name  = "mobius.persistentVolume.claimName"
    value = var.mobius-kube["persistentVolume_claimName"]
  }
  set {
    name  = "mobius.persistentVolume.size"
    value = var.mobius-kube["persistentVolume_size"]
  }

  set {
    name  = "mobius.mobiusDiagnostics.persistentVolume.volumeName"
    value = var.mobius-kube["mobiusDiagnostics_persistentVolume_volumeName"]
  }
  set {
    name  = "mobius.mobiusDiagnostics.persistentVolume.claimName"
    value = var.mobius-kube["mobiusDiagnostics_persistentVolume_claimName"]
  }
  set {
    name  = "mobius.mobiusDiagnostics.persistentVolume.size"
    value = var.mobius-kube["mobiusDiagnostics_persistentVolume_size"]
  }
  set {
    name  = "mobius.clustering.kubernetes.namespace"
    value = var.namespace
  }
}

###### Mobius View
resource "kubernetes_secret" "mobiusview-server-secrets" {
  metadata {
    name = var.mobiusview-kube["datasource_databaseConnectivitySecretName"]
    namespace  = var.namespace
  }
  data = {
    url      = var.mobiusview["SPRING_DATASOURCE_URL"]
    username = var.mobiusview["SPRING_DATASOURCE_USERNAME"]
    password = var.mobiusview["SPRING_DATASOURCE_PASSWORD"]
  }
}

resource "kubernetes_secret" "mobiusview_license" {
  metadata {
    name = "mobius-license"
    namespace  = var.namespace
  }
  data = {
    license = var.mobiusview["MOBIUS_LICENSE"]
  }
}

resource "kubernetes_persistent_volume_claim" "mobiusview12-storage" {
  metadata {
    name = var.mobiusview-kube["master_persistence_claimName"]
    namespace  = var.namespace
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "1Gi"
      }
    }
  }
}
resource "kubernetes_persistent_volume_claim" "mobiusview12-diag" {
  metadata {
    name = var.mobiusview-kube["master_mobiusViewDiagnostics_persistentVolume_claimName"]
    namespace  = var.namespace
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "1Gi"
      }
    }
  }
}
resource "kubernetes_persistent_volume_claim" "mobiusview12-pres" {
  metadata {
    name = var.mobiusview-kube["master_presentations_persistentVolume_claimName"]
    namespace  = var.namespace
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "1Gi"
      }
    }
  }
}
resource "helm_release" "mobiusview12" {
  name             = "mobiusview12"
  chart            = "${path.module}/helm/mobiusview-12.0.0"
  namespace        = var.namespace
  create_namespace = true

  set {
    name  = "image.repository"
    value = var.mobiusview-kube["image_repository"]
  }
  set {
    name  = "image.tag"
    value = var.mobiusview-kube["image_tag"]
  }
  #---------------
  set {
    name  = "master.persistence.claimName"
    value = var.mobiusview-kube["master_persistence_claimName"]
  }
  set {
    name  = "master.persistence.accessMode"
    value = var.mobiusview-kube["master_persistence_accessMode"]
  }
  set {
    name  = "master.persistence.size"
    value = var.mobiusview-kube["master_persistence_size"]
  }
  #---------------
  set {
    name  = "master.mobiusViewDiagnostics.persistentVolume.claimName"
    value = var.mobiusview-kube["master_mobiusViewDiagnostics_persistentVolume_claimName"]
  }
  set {
    name  = "master.mobiusViewDiagnostics.persistentVolume.accessMode"
    value = var.mobiusview-kube["master_mobiusViewDiagnostics_persistentVolume_accessMode"]
  }
  set {
    name  = "master.mobiusViewDiagnostics.persistentVolume.size"
    value = var.mobiusview-kube["master_mobiusViewDiagnostics_persistentVolume_size"]
  }
  #---------------
  set {
    name  = "master.presentations.persistentVolume.claimName"
    value = var.mobiusview-kube["master_presentations_persistentVolume_claimName"]
  }
  set {
    name  = "master.presentations.persistentVolume.accessMode"
    value = var.mobiusview-kube["master_presentations_persistentVolume_accessMode"]
  }
  set {
    name  = "master.presentations.persistentVolume.size"
    value = var.mobiusview-kube["master_presentations_persistentVolume_size"]
  }
  #---------------
  set {
    name  = "initRepository.host"
    value = var.mobiusview["MOBIUS_HOST"]
  }

  set {
    name  = "initRepository.port"
    value = var.mobiusview["MOBIUS_PORT"]
  }

  set {
    name  = "ingress.hosts[0].host"
    value = "mobius12.local.net"
  }

}

