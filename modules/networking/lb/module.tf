##local block need to be deleted###
locals {
  frontend_ip_configurations = length(try(var.settings.frontend_ip_configurations, [])) > 0 ?
    var.settings.frontend_ip_configurations :
    (try(var.settings.frontend_ip_configuration, null) != null ? [var.settings.frontend_ip_configuration] : [])

  frontend_ip_map = { for idx, cfg in local.frontend_ip_configurations : tostring(idx) => cfg }
}


resource "azurecaf_name" "lb" {
  name          = var.settings.name
  resource_type = "azurerm_lb"
  prefixes      = var.global_settings.prefixes
  random_length = var.global_settings.random_length
  clean_input   = true
  passthrough   = var.global_settings.passthrough
  use_slug      = var.global_settings.use_slug
}
resource "azurerm_lb" "lb" {
  name                = azurecaf_name.lb.result
  resource_group_name = var.resource_group_name
  location            = var.location

  #frontend_ip_configuration {
  #    name                                               = azurecaf_name.lb[each.key].result
  #    gateway_load_balancer_frontend_ip_configuration_id = try(each.value.gateway_load_balancer_frontend_ip_configuration_id, null)
  #    private_ip_address                                 = lookup(each.value, "private_ip_address", null)
  #    private_ip_address_allocation                      = lookup(each.value, "private_ip_address_allocation", "Dynamic")
  #    private_ip_address_version                         = lookup(each.value, "private_ip_address_version", null)
  #    public_ip_prefix_id                                = try(each.value.public_ip_prefix_id, null)
  #    zones                                              = can(each.value.zones) ? each.value.zones : try(each.value.availability_zone, null)
      # TODO: availability_zone kept for smooth migration to 3.0

  #    public_ip_address_id = can(each.value.public_address_id) || can(try(each.value.public_ip_address.key, each.value.public_ip_address_key)) == false ? try(each.value.public_address_id, null) : var.public_ip_addresses[try(each.value.public_ip_address.lz_key, var.client_config.landingzone_key)][try(each.value.public_ip_address.key, each.value.public_ip_address_key)].id
  #    subnet_id            = can(each.value.subnet_id) || can(each.value.vnet_key) == false ? try(each.value.subnet_id, var.virtual_subnets[try(each.value.lz_key, var.client_config.landingzone_key)][each.value.subnet_key].id) : var.vnets[try(each.value.lz_key, var.client_config.landingzone_key)][each.value.vnet_key].subnets[each.value.subnet_key].id
  #   }

#     dynamic "frontend_ip_configuration" {
#     #for_each = try(var.settings.frontend_ip_configuration, null) != null ? [var.settings.frontend_ip_configuration] : []
#     for_each = try(var.settings.frontend_ip_configuration, [])
#     content {
#       name                                               = try(frontend_ip_configuration.value.name, null)
#       gateway_load_balancer_frontend_ip_configuration_id = try(frontend_ip_configuration.value.gateway_load_balancer_frontend_ip_configuration_id, null)
#       private_ip_address                                 = try(frontend_ip_configuration.value.private_ip_address, null)
#       private_ip_address_allocation                      = try(frontend_ip_configuration.value.private_ip_address_allocation, null)
#       private_ip_address_version                         = try(frontend_ip_configuration.value.private_ip_address_version, null)
#       public_ip_prefix_id                                = try(frontend_ip_configuration.value.public_ip_prefix_id, null)
#       zones                                              = can(frontend_ip_configuration.value.zones) ? frontend_ip_configuration.value.zones : try(frontend_ip_configuration.value.availability_zone, null)
#       # TODO: availability_zone kept for smooth migration to 3.0

#       public_ip_address_id = can(frontend_ip_configuration.value.public_ip_address.id) || can(frontend_ip_configuration.value.public_ip_address.key) ? try(frontend_ip_configuration.value.public_ip_address.id, var.remote_objects.public_ip_addresses[try(frontend_ip_configuration.value.public_ip_address.lz_key, var.client_config.landingzone_key)][frontend_ip_configuration.value.public_ip_address.key].id) : null
#       subnet_id            = can(frontend_ip_configuration.value.subnet.id) || can(frontend_ip_configuration.value.subnet.key) ? try(frontend_ip_configuration.value.subnet.id, var.remote_objects.virtual_network[try(frontend_ip_configuration.value.subnet.lz_key, var.client_config.landingzone_key)][frontend_ip_configuration.value.subnet.vnet_key].subnets[frontend_ip_configuration.value.subnet.key].id) : null

#      }
#   }

##new changes###
dynamic "frontend_ip_configuration" {
  # convert single object into a map so each.key exists; produce empty map if missing
  for_each = try(var.settings.frontend_ip_configuration, null) != null ? { "single" = var.settings.frontend_ip_configuration } : {}

  content {
    # ensure name never null by falling back to a generated name with key
    name = try(each.value.name, "${azurecaf_name.lb.result}-fe-${each.key}")

    gateway_load_balancer_frontend_ip_configuration_id = try(each.value.gateway_load_balancer_frontend_ip_configuration_id, null)
    private_ip_address                                 = try(each.value.private_ip_address, null)
    private_ip_address_allocation                      = try(each.value.private_ip_address_allocation, "Dynamic")
    private_ip_address_version                         = try(each.value.private_ip_address_version, null)
    public_ip_prefix_id                                = try(each.value.public_ip_prefix_id, null)
    zones                                              = can(each.value.zones) ? each.value.zones : try(each.value.availability_zone, null)

    public_ip_address_id = (
      can(each.value.public_ip_address) && (can(each.value.public_ip_address.id) || can(each.value.public_ip_address.key))
      ? try(
          each.value.public_ip_address.id,
          var.remote_objects.public_ip_addresses[
            try(each.value.public_ip_address.lz_key, var.client_config.landingzone_key)
          ][each.value.public_ip_address.key].id
        )
      : null
    )

    subnet_id = (
      can(each.value.subnet) && (can(each.value.subnet.id) || can(each.value.subnet.key))
      ? try(
          each.value.subnet.id,
          var.remote_objects.virtual_network[
            try(each.value.subnet.lz_key, var.client_config.landingzone_key)
          ][each.value.subnet.vnet_key].subnets[each.value.subnet.key].id
        )
      : null
    )
  }
}


  sku      = try(title(var.settings.sku), null)
  sku_tier = try(title(var.settings.sku_tier), null)
  tags     = local.tags
}
