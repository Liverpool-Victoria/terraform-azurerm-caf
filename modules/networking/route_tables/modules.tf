resource "azurerm_route_table" "rt" {
  name                          = var.name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  bgp_route_propagation_enabled = var.disable_bgp_route_propagation == null ? null : !var.disable_bgp_route_propagation
  tags                          = local.tags
}
