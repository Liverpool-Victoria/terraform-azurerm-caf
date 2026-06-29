# Azure Database for MySQL Single Server was retired; all azurerm_mysql_* resources
# were removed in azurerm provider 4.x. Use modules/databases/mysql_flexible_server instead.

resource "azurecaf_name" "mysql" {
  name          = var.settings.name
  resource_type = "azurerm_mysql_server"
  prefixes      = var.global_settings.prefixes
  random_length = var.global_settings.random_length
  clean_input   = true
  passthrough   = var.global_settings.passthrough
}
