output "cosmosdb_sql_databases" {
  value = module.cosmosdb_sql_databases
}

module "cosmosdb_sql_databases" {
  source   = "./modules/databases/cosmos_dbs/sql_database"
  for_each = local.database.cosmosdb_sql_databases

  global_settings       = local.global_settings
  settings              = each.value
  resource_group_name   = try(local.combined_objects_cosmos_dbs[local.client_config.landingzone_key][each.value.cosmosdb_account_key].resource_group_name, local.combined_objects_cosmos_dbs[each.value.lz_key][each.value.cosmosdb_account_key].resource_group_name)
  location              = try(local.combined_objects_cosmos_dbs[local.client_config.landingzone_key][each.value.cosmosdb_account_key].location, local.combined_objects_cosmos_dbs[each.value.lz_key][each.value.cosmosdb_account_key].location)
  cosmosdb_account_name = try(local.combined_objects_cosmos_dbs[local.client_config.landingzone_key][each.value.cosmosdb_account_key].name, local.combined_objects_cosmos_dbs[each.value.lz_key][each.value.cosmosdb_account_key].name)
}
