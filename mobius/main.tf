############### HELM FOR MOBIUS AND MOBIUS-VIEW #############
locals {
  my_registry = "${var.KUBE_LOCALREGISTRY_HOST}:${var.KUBE_LOCALREGISTRY_PORT}"
}
resource "helm_release" "mobius12" {
  name             = "mobius12"
  chart            = "${path.module}/helm/mobius.tgz"
  namespace        = var.NAMESPACE
  create_namespace = true

 set {
    name  = "image.repository"
    value = "${local.my_registry}/mobius-server"
  }

  set {
    name  = "image.tag"
    value = var.IMAGE_VERSION_MOBIUS
  }

  set {
    name  = "storageClassName"
    value = var.mobius_storageClassName
  }

  set {
    name  = "mobius.admin.user"
    value = var.MOBIUS_ADMIN_USER
  }

  set {
    name  = "mobius.admin.group"
    value = var.MOBIUS_ADMIN_GROUP
  }

  set {
    name  = "mobius.rds.provider"
    value = var.RDSPROVIDER
  }
  set {
    name  = "mobius.rds.port"
    value = var.POSTGRESQL_PORT
  }

  set {
    name  = "mobius.fts.enabled"
    value = var.ENABLEINDEX
     }
  set {
    name  = "mobius.fts.host"
    value = var.MOBIUS_FTS_HOST
     }
   
  set {
    name  = "mobius.fts.port"
    value = var.MOBIUS_FTS_PORT
     }        

  set {
    name  = "mobius.fts.indexName"
    value = var.MOBIUS_FTS_INDEX_NAME
     } 

   set {
    name  = "spring.kafka.bootstrap.servers"
    value = var.KAFKA_BOOTSTRAP_URL
     } 
  set {
    name  = "mobius.persistentVolume.claimName"
    value = var.mobius_persistentVolume_claimName
  }
  set {
    name  = "mobius.persistentVolume.enabled"
    value = "true"
  }
  set {
    name  = "mobius.mobiusDiagnostics.persistentVolume.claimName"
    value = var.mobius_mobiusDiagnostics_persistentVolume_claimName
  }
   set {
    name  = "mobius.mobiusDiagnostics.persistentVolume.enabled"
    value = "true"
  }
  set {
    name  = "mobius.clustering.kubernetes.namespace"
    value = var.NAMESPACE
  }

}  
/*
resource "helm_release" "mobiusview12" {
  name             = "mobiusview12"
  chart            = "${path.module}/helm/mobiusview.tgz"
  namespace        = var.NAMESPACE
  create_namespace = true

  values = [
    templatefile("${path.module}/helm/mobiusview.tpl", {
      NAMESPACE = var.NAMESPACE
      KUBE_LOCALREGISTRY_HOST = var.KUBE_LOCALREGISTRY_HOST
      KUBE_LOCALREGISTRY_PORT = var.KUBE_LOCALREGISTRY_PORT
      IMAGE_NAME_MOBIUSVIEW = var.IMAGE_NAME_MOBIUSVIEW
      IMAGE_VERSION_MOBIUSVIEW = var.IMAGE_VERSION_MOBIUSVIEW
      POSTGRESQL_HOST = var.POSTGRESQL_HOST
      POSTGRESQL_PORT = var.POSTGRESQL_PORT
      POSTGRESQL_DBNAME_MOBIUSVIEW = var. POSTGRESQL_DBNAME_MOBIUSVIEW 
      POSTGRESQL_USERNAME = var.POSTGRESQL_USERNAME
      POSTGRESQL_PASSWORD = var.POSTGRESQL_PASSWORD
      MOBIUS_FTS_INDEX_NAME = var.MOBIUS_FTS_INDEX_NAME
      MOBIUS_HOST = var.MOBIUS_HOST
      MOBIUS_PORT = var.MOBIUS_PORT
      KAFKA_BOOTSTRAP_URL = var.KAFKA_BOOTSTRAP_URL
      MOBIUS_VIEW_URL = var.MOBIUS_VIEW_URL
      master_persistence_claimName = var.mobiusview_master_persistence_claimName
      master_mobiusViewDiagnostics_persistentVolume_claimName = var.mobiusview_master_mobiusViewDiagnostics_persistentVolume_claimName
      master_presentations_persistentVolume_claimName = var.mobiusview_master_presentations_persistentVolume_claimName
      
    })
  ]
}
*/