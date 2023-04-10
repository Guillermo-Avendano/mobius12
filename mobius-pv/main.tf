
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

resource "kubernetes_persistent_volume" "mobius12-efs" {
  metadata {
    name = "pv-mobius12-efs"
  }
  spec {
    access_modes = ["ReadWriteMany"]
    capacity = {
      storage = "1Gi"
    }
    persistent_volume_source {
      host_path {
        path = "/home/rocket/pv-mobius12-efs"
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim" "mobius12-efs" {
  metadata {
    name = "pvc-mobius12-efs"
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
  }
  spec {
    access_modes = ["ReadWriteMany"]
    capacity = {
      storage = "1Gi"
    }
    persistent_volume_source {
      host_path {
        path = "/home/rocket/pv-mobius12-diag"
      }
    }
  }
}
resource "kubernetes_persistent_volume_claim" "mobius12-diag" {
  metadata {
    name = "pvc-mobius12-diagnose"
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
