variable "kube_config" {
  type    = string
  default = "~/.kube/config"
}

variable "namespace" {
  type    = string
  default = "mobius-tech"
}

variable "namespace_shared" {
  type    = string
  default = "shared"
}