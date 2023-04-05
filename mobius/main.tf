
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
    name       = var.mobius-kube["persistentVolume_claimName"]
    namespace  = var.namespace
  }
  spec {
    access_modes = ["ReadWriteMany"]
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
    namespace = var.namespace
  }
  spec {
    access_modes = ["ReadWriteMany"]
    resources {
      requests = {
        storage = "1Gi"
      }
    }

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
