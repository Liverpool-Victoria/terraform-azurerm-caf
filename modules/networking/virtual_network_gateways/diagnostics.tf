module "diagnostics" {
  source = "../../diagnostics"

  resource_id       = azurerm_virtual_network_gateway.vngw.id
  resource_location = azurerm_virtual_network_gateway.vngw.location
  diagnostics       = var.diagnostics
  profiles          = try(var.settings.diagnostic_profiles, {})
}
