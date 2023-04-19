
variable "kube_config" {
  type    = string
  default = "../cluster/cluster-config.yaml"
}

variable "NAMESPACE_MOBIUS" {
  type    = string
  default = "mobius"
}

variable "NAMESPACE_SHARED" {
  type    = string
  default = "shared"  
}

variable "PGADMIN_URL" {
  type    = string
  default = "pgadmin.local.net"  
}

variable "ELASTIC_URL" {
  type    = string
  default = "elastic.local.net"  
}