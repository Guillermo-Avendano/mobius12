
variable "kube_config" {
  type    = string
  default = "${path.module}/../cluster/cluster-config.yaml"
}

variable "NAMESPACE_MOBIUS" {
  type    = string
  default = "mobius"
}

variable "NAMESPACE_SHARED" {
  type    = string
  default = "shared"  
}