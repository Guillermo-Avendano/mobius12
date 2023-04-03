resource "helm_release" "postgres" {
  name       = "postgres"
  chart      = "${path.module}/helm/shared-postgres"
  namespace  = "shared"
  create_namespace = true

  set {
    name  = "global.postgresql.auth.postgresPassword"
    value = "postgres"
  }

  set {
    name  = "primary.initdb.scripts.create-databases\\.sql"
    value = "${file("mobius.sql")}"
   }
} 

resource "helm_release" "kafka" {
  name       = "kafka"
  chart      = "${path.module}/helm/shared-kafka"
  namespace  = "shared"
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