###### Postgres
resource "kubernetes_namespace" "shared" {
  metadata {
    annotations = {
      name = var.NAMESPACE_SHARED
    }

    labels = {
      mylabel = "shared"
    }

    name = var.NAMESPACE_SHARED
  }
}

#-- Secret for postgres password
resource "kubernetes_secret" "postgres" {
  metadata {
    name = "postgres-secrets"
    namespace  = var.NAMESPACE_SHARED
  }

  data = {
    postgres-password = "postgres"
  }
  depends_on = [kubernetes_namespace.shared]
}

resource "helm_release" "postgres" {
  name       = "postgres"
  chart      = "${path.module}/helm/shared-postgres"
  namespace  = var.NAMESPACE_SHARED
  create_namespace = true
  
  set {
    name  = "global.postgresql.auth.existingSecret"
    value = "postgres-secrets"
  }
  set {
    name  = "global.postgresql.auth.secretKeys.adminPasswordKey"
    value = "postgres-password"
  }
  
  set {
    name  = "primary.initdb.scripts.create-databases\\.sql"
    value = "${file("mobius.sql")}"
   }

   depends_on = [kubernetes_secret.postgres]
} 


###### Kafka deloyment
resource "helm_release" "pgadmin" {
  name       = "pgadmin"
  chart      = "${path.module}/helm/shared-pgadmin4"
  namespace  = var.NAMESPACE_SHARED
  create_namespace = true

  set {
    name  = "namespace"
    value = var.NAMESPACE_SHARED
  }
  
  set {
    name  = "image.repository"
    value = "dpage/pgadmin4"
  }
  set {
    name  = "image.tag"
    value = "latest"
   }

}

###### Kafka deloyment
resource "helm_release" "kafka" {
  name       = "kafka"
  chart      = "${path.module}/helm/shared-kafka"
  namespace  = var.NAMESPACE_SHARED
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
  namespace  = var.NAMESPACE_SHARED
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

