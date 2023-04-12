
variable "kube_config" {
  type    = string
  default = "~/.kube/config"
}

variable "NAMESPACE_MOBIUS" {
  type    = string
  default = "mobius"
}

variable "NAMESPACE_SHARED" {
  type    = string
  default = "shared"  
}