output "id" {
  value       = null
  description = "MySQL Single Server is no longer supported by the AzureRM provider 4.x."
}

output "fqdn" {
  value       = null
  description = "MySQL Single Server is no longer supported by the AzureRM provider 4.x."
}

output "rbac_id" {
  value       = null
  description = "MySQL Single Server is no longer supported by the AzureRM provider 4.x."
}

output "identity" {
  value       = null
  description = "MySQL Single Server is no longer supported by the AzureRM provider 4.x."
}

output "name" {
  value       = azurecaf_name.mysql.result
  description = "Planned MySQL server name (Single Server is not deployable in azurerm 4.x)."
}

output "resource_group_name" {
  value = local.resource_group_name
}

output "location" {
  value = local.location
}
