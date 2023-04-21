############### SECRETS FOR MOBIUS #############

resource "kubernetes_secret" "mobius12" {
  metadata {
    name = "mobius-server-secrets"
    namespace  = var.NAMESPACE
  }
  data = {
    user = var.POSTGRESQL_USERNAME
    schema = var.POSTGRESQL_USERNAME
    password = var.POSTGRESQL_PASSWORD
    endpoint = var.POSTGRESQL_HOST
    port = var.POSTGRESQL_PORT
    topicUrl = "jdbc:postgresql://${var.POSTGRESQL_HOST}:${var.POSTGRESQL_PORT}/${var.POSTGRESQL_DBNAME_EVENTANALYTICS}"
    topicUser = var.POSTGRESQL_USERNAME
    topicPassword = var.POSTGRESQL_PASSWORD
  }
}