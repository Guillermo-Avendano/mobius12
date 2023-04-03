
data "template_file" "create_db" {
  template = <<-EOF
    CREATE ROLE "mobiusserver12" WITH LOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE INHERIT NOREPLICATION CONNECTION LIMIT -1 PASSWORD 'postgres';
    CREATE ROLE "mobiusview12" WITH LOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE INHERIT NOREPLICATION CONNECTION LIMIT -1 PASSWORD 'postgres';
    CREATE ROLE "eventanalytics" WITH LOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE INHERIT NOREPLICATION CONNECTION LIMIT -1 PASSWORD 'postgres';
    CREATE DATABASE "mobiusserver12" WITH OWNER = "mobiusserver12" TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'C' LC_CTYPE = 'C' TABLESPACE = pg_default CONNECTION LIMIT = -1;
    CREATE DATABASE "mobiusview12" WITH OWNER = "mobiusview12" TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'C' LC_CTYPE = 'C' TABLESPACE = pg_default CONNECTION LIMIT = -1;
    CREATE DATABASE "eventanalytics" WITH OWNER = "eventanalytics" TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'C' LC_CTYPE = 'C' TABLESPACE = pg_default CONNECTION LIMIT = -1;
  EOF
}
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
    name  = "postgresqlInitdbSql"
    value = "${data.template_file.create_db.rendered}"
  }

}