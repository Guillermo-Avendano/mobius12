########## Mobius 12
#-- define secret for postgres password
resource "kubernetes_secret" "mobius12" {
  metadata {
    name = "mobius-server-secrets"
    namespace  = "mobius-tech"
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
  namespace  = "mobius-tech"
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