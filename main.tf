#-- define secret for postgres password
resource "null_resource" "health_check" {

 provisioner "local-exec" {
    
    command = "/bin/bash healthcheck.sh"
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
    value = "pv-mobius12-diagnose"
   }
   set {
    name = "mobius.mobiusDiagnostics.persistentVolume.claimName"
    value = "pvc-mobius12-diagnose"
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