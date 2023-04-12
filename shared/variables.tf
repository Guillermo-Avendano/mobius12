locals {
  namespace_mobius_from_env = try(var.namespace_mobius_from_env != null ? var.namespace_mobius_from_env : lookup(env, "TF_VAR_NAMESPACE"), "Error: TF_VAR_NAMESPACE environment variable not set.")
  namespace_shared_from_env = try(var.namespace_shared_from_env != null ? var.namespace_shared_from_env : lookup(env, "TF_VAR_NAMESPACE_SHARED"), "Error: TF_VAR_NAMESPACE_SHARED environment variable not set.")
}

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