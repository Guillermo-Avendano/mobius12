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

  values = [
    jsonencode({
      ingress = {
        enabled = true
        className = "nginx"
        annotations = {
          "nginx.ingress.kubernetes.io/proxy-body-size"            = "32m"
          "nginx.ingress.kubernetes.io/affinity"                   = "cookie"
          "nginx.ingress.kubernetes.io/session-cookie-name"        = "session-cookie"
          "nginx.ingress.kubernetes.io/session-cookie-expires"     = "172800"
          "nginx.ingress.kubernetes.io/session-cookie-max-age"     = "172800"
          "nginx.ingress.kubernetes.io/ssl-redirect"               = "false"
          "nginx.ingress.kubernetes.io/affinity-mode"              = "persistent"
          "nginx.ingress.kubernetes.io/session-cookie-change-on-failure" = "false"
          "nginx.ingress.kubernetes.io/session-cookie-hash"        = "sha1"
          "nginx.ingress.kubernetes.io/session-cookie-path"        = "/pgadmin4"
          "nginx.ingress.kubernetes.io/proxy-buffer-size"          = "8k"
          "nginx.ingress.kubernetes.io/configuration-snippet"      = "proxy_set_header X-Script-Name /pgadmin4;"
        }
        hosts = [
          {
            host  = "pgadmin.local.net" # new host
            paths = [
              {
                path     = "/pgadmin4"
                pathType = "ImplementationSpecific"
              }
            ]
          }
        ]
      }
    })
  ]

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

  values = [
    jsonencode({
      ingress = {
        enabled = true
        className = "nginx"
        annotations = {
          "nginx.ingress.kubernetes.io/use-regex"            = "true"
          "nginx.ingress.kubernetes.io/rewrite-target"       = "/$2"
        }
        hosts = [
          {
            host  = "elastic.local.net" # new host
            paths = [
              {
                path     = "/elastic(/|$)(.*)"
                pathType = "ImplementationSpecific"
              }
            ]
          }
        ]
      }
    })
  ]

}

