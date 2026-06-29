variable "global_settings" {
  description = "Global settings object (see module README.md)"
}
variable "client_config" {
  description = "Client configuration object (see module README.md)."
}
variable "settings" {}
variable "primary_server_id" {
  description = "The ID of the primary SQL Server."
  type        = string
}
variable "secondary_server_id" {}
variable "databases" {}