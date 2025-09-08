

module "recovery_services_vaults" {
  source   = "../../resources/tf-azurerm-recovery-services-vault"
  for_each = { for recovery_services_vault in var.recovery_services_vaults : recovery_services_vault.name => recovery_services_vault }

  vault_name          = each.key
  resource_group_name = each.value.resource_group_name
  location            = try(each.value.location, var.common_vars.location)
  sku                 = each.value.sku
  storage_mode_type   = each.value.storage_mode_type
  soft_delete_enabled = each.value.soft_delete_enabled
  identity            = each.value.identity
  vm_backup_policies  = each.value.vm_backup_policies
  tags                = try(each.value.tags, var.common_vars.tags)
  common_vars         = var.common_vars
  private_endpoints             = try(each.value.private_endpoints, [
    for private_endpoint in each.value.private_endpoints : {
      name                                 = private_endpoint.name
      resource_group_name                  = private_endpoint.resource_group_name
      private_service_connection_name      = private_endpoint.private_service_connection_name
      is_manual_connection                 = private_endpoint.is_manual_connection
      subnet_name                          = private_endpoint.subnet_name
      subnet_vnet_name                     = private_endpoint.subnet_vnet_name
      subnet_resource_group_name           = private_endpoint.subnet_resource_group_name
      subnet_subscription_id               = private_endpoint.subnet_subscription_id
      subresource_names                    = private_endpoint.subresource_names
      private_dns_zone_name                = private_endpoint.private_dns_zone_name
      private_dns_zone_resource_group_name = private_endpoint.private_dns_zone_resource_group_name
      private_dns_zone_subscription_id     = private_endpoint.private_dns_zone_subscription_id
    }
  ])
  public_network_access_enabled = try(each.value.public_network_access_enabled, false)

  diagnostic_settings                         = try(each.value.diagnostic_settings, [])
  log_analytics_workspace_subscription_id     = try(var.monitor_diagnostic_shared_settings.log_analytics_workspace_subscription_id, null)
  log_analytics_workspace_resource_group_name = try(var.monitor_diagnostic_shared_settings.log_analytics_workspace_resource_group_name, null)
  log_analytics_workspace_name                = try(var.monitor_diagnostic_shared_settings.log_analytics_workspace_name, null)

  providers = {
    azurerm.logs = azurerm.logs
  }
}
