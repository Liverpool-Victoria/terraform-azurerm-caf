terraform {
  required_providers {
    azurecaf = {
      source = "aztfmod/azurecaf"
    }
  }
}

locals {
  module_tag = {
    "module" = basename(abspath(path.module))
  }
  tags = merge(var.base_tags, local.module_tag)

  container_group_subnet_ids = try(
    var.settings.subnet_ids,
    try(var.settings.subnet_id, null) != null ? [var.settings.subnet_id] : null,
    try(var.settings.network_profile, null) != null ? compact([
      for ip_config in try(
        var.settings.network_profile.container_network_interface.ip_configurations,
        var.settings.network_profile.ip_configurations,
        []
      ) : coalesce(
        try(ip_config.subnet_id, null),
        try(var.combined_resources.vnets[try(ip_config.lz_key, var.client_config.landingzone_key)][ip_config.vnet_key].subnets[ip_config.subnet_key].id, null)
      )
    ]) : []
  )
}