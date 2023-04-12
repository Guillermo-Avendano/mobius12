
variable "kube_config" {
  type    = string
  default = "~/.kube/config"
}

variable "namespace_mobius" {
  type    = string
  default = var.namespace_mobius_from_env
}

variable "namespace_shared" {
  type    = string
  default = var.namespace_shared_from_env
}