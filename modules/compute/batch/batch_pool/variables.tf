variable "global_settings" {
  description = "Global settings object (see module README.md)"
}
variable "client_config" {
  description = "Client configuration object (see module README.md)."
}
variable "settings" {}
variable "account_name" {}
variable "resource_group_name" {}
variable "managed_identities" {
  default = {}
}
variable "batch_certificates" {
  default = {}
}
