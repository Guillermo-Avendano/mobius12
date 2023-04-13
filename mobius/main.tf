locals {
  mobius_tls_key = "${path.module}/cert/${var.MOBIUS_VIEW_URL}.key"
  mobius_tls_crt = "${path.module}/cert/${var.MOBIUS_VIEW_URL}.crt"
  mobius_server_version = var.mobius-kube["MOBIUS_SERVER_VERSION"]
  mobius_view_version = var.mobius-kube["MOBIUS_VIEW_VERSION"]
  eventanalytics_version = var.mobius-kube["EVENTANALYTICS_VERSION"]
  my_registry = "${var.mobius-kube["MOBIUS_LOCALREGISTRY_HOST"]}:${var.mobius-kube["MOBIUS_LOCALREGISTRY_PORT"]}"
}
/*
resource "kubernetes_namespace" "mobius" {
  metadata {
    annotations = {
      name = var.NAMESPACE
    }

    labels = {
      mylabel = "mobius"
    }

    name = var.NAMESPACE
  }
}
*/

resource "kubernetes_persistent_volume_claim" "mobius12-efs" {
  metadata {
    name = var.mobius-kube["persistentVolume_claimName"]
    namespace  = var.NAMESPACE
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "1Gi"
      }
    }
  }
  # 
}

resource "kubernetes_persistent_volume_claim" "mobius12-diag" {
  metadata {
    name = var.mobius-kube["mobiusDiagnostics_persistentVolume_claimName"]
    namespace  = var.NAMESPACE
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "1Gi"
      }
    }
  }
  # 
}

resource "kubernetes_secret" "mobius12" {
  metadata {
    name = "mobius-server-secrets"
    namespace  = var.NAMESPACE
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
  # 
}

resource "helm_release" "mobius12" {
  name             = "mobius12"
  chart            = "${path.module}/helm/mobius-12.0.0"
  namespace        = var.NAMESPACE
  create_namespace = true

  set {
    name  = "image.repository"
    value = "${local.my_registry}/mobius-server"
  }

  set {
    name  = "image.tag"
    value = "${local.mobius_server_version}"
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
    value = var.NAMESPACE
  }
  depends_on = [kubernetes_secret.mobius12]
}

###### Mobius View
resource "kubernetes_secret" "mobiusview-server-secrets" {
  metadata {
    name = var.mobiusview-kube["datasource_databaseConnectivitySecretName"]
    namespace  = var.NAMESPACE
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
    namespace  = var.NAMESPACE
  }
  data = {
    license = var.mobiusview["MOBIUS_LICENSE"]
  }
  
}


resource "kubernetes_secret" "mobius-tls-secret" {
  metadata {
    name = var.MOBIUS_VIEW_TLS_SECRET
    namespace  = var.NAMESPACE
  }

  data = {
    "tls.crt" = filebase64(local.mobius_tls_crt)
    "tls.key" = filebase64(local.mobius_tls_key)
  }

  type = "kubernetes.io/tls"
}

/*
resource "kubernetes_persistent_volume_claim" "mobiusview12-storage" {
  metadata {
    name = var.mobiusview-kube["master_persistence_claimName"]
    namespace  = var.NAMESPACE
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
    namespace  = var.NAMESPACE
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
    namespace  = var.NAMESPACE
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
*/
resource "helm_release" "mobiusview12" {
  name             = "mobiusview12"
  chart            = "${path.module}/helm/mobiusview-12.0.0"
  namespace        = var.NAMESPACE
  create_namespace = true

  set {
    name  = "image.repository"
    value = "${local.my_registry}/mobius-view"
  }

  set {
    name  = "image.tag"
    value = "${local.mobius_view_version}"
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

 values = [
    jsonencode({
      ingress = {
        enabled = true
        className = "nginx"
        annotations = {
          "nginx.ingress.kubernetes.io/rewrite-target"             = "/mobius$1"
          "nginx.ingress.kubernetes.io/proxy-body-size"            = "32m"
          "nginx.ingress.kubernetes.io/affinity"                   = "cookie"
          "nginx.ingress.kubernetes.io/session-cookie-name"        = "session-cookie"
          "nginx.ingress.kubernetes.io/session-cookie-expires"     = "172800"
          "nginx.ingress.kubernetes.io/session-cookie-max-age"     = "172800"
          "nginx.ingress.kubernetes.io/ssl-redirect"               = "false"
          "nginx.ingress.kubernetes.io/affinity-mode"              = "persistent"
          "nginx.ingress.kubernetes.io/session-cookie-change-on-failure" = "false"
          "nginx.ingress.kubernetes.io/session-cookie-hash"        = "sha1"
          "nginx.ingress.kubernetes.io/session-cookie-path"        = "/mobius"
          "nginx.ingress.kubernetes.io/proxy-buffer-size"          = "8k"
        }
        hosts = [
          {
            host  = var.MOBIUS_VIEW_URL # new host
            paths = [
              {
                path     = "/mobius(.*)$"
                pathType = "ImplementationSpecific"
              }
            ]
          }
        ]
        tls = [
        {
          secretName = var.MOBIUS_VIEW_TLS_SECRET
          hosts = [ var.MOBIUS_VIEW_URL ]
        }
      ]
      }
    })
  ]

  depends_on = [kubernetes_secret.mobiusview-server-secrets,
                kubernetes_secret.mobiusview_license,
                kubernetes_secret.mobius-tls-secret]
}