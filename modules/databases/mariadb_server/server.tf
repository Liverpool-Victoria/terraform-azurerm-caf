# Azure Database for MariaDB was retired; all azurerm_mariadb_* resources
# were removed in azurerm provider 4.x. Use azurerm_mysql_flexible_server instead.

resource "azurecaf_name" "mariadb" {
  name          = var.settings.name
  resource_type = "azurerm_mariadb_server"
  prefixes      = var.global_settings.prefixes
  random_length = var.global_settings.random_length
  clean_input   = true
  passthrough   = var.global_settings.passthrough
}
