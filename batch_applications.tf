module "batch_applications" {
  source   = "./modules/compute/batch/batch_application"
  for_each = local.compute.batch_applications

  global_settings     = local.global_settings
  client_config       = local.client_config
  settings            = each.value
  account_name        = local.combined_objects_batch_accounts[try(each.value.keyvault.lz_key, local.client_config.landingzone_key)][each.value.batch_account_key].name
  resource_group_name = can(each.value.resource_group.name) || can(each.value.resource_group_name) ? try(each.value.resource_group.name, each.value.resource_group_name) : local.combined_objects_resource_groups[try(each.value.resource_group.lz_key, local.client_config.landingzone_key)][try(each.value.resource_group_key, each.value.resource_group.key)].name
}

output "batch_applications" {
  value = module.batch_applications
}
