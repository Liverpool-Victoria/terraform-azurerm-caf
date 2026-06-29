output "id" {
  value       = null
  description = "MariaDB Server is no longer supported by the AzureRM provider 4.x."
}

output "fqdn" {
  value       = null
  description = "MariaDB Server is no longer supported by the AzureRM provider 4.x."
}

output "name" {
  value       = azurecaf_name.mariadb.result
  description = "Planned MariaDB server name (not deployable in azurerm 4.x)."
}

output "resource_group_name" {
  value = local.resource_group_name
}

output "location" {
  value = var.location
}
