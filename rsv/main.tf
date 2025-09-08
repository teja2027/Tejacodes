data "azurerm_subscription" "current" {
}

resource "azurerm_recovery_services_vault" "vault" {
  name                         = lower(var.vault_name)
  location                     = var.location
  resource_group_name          = var.resource_group_name
  tags                         = var.tags
  sku                          = var.sku
  storage_mode_type            = var.storage_mode_type
  cross_region_restore_enabled = var.cross_region_restore_enabled
  soft_delete_enabled          = var.soft_delete_enabled
  dynamic "identity" {
    for_each = var.identity != null ? [var.identity] : []
    iterator = i

    content {
      type = i.value.type
    }
  }
  dynamic "encryption" {
    for_each = var.encryption != null ? [var.encryption] : []
    iterator = j

    content {
      key_id                            = j.value.key_id
      infrastructure_encryption_enabled = j.value.infrastructure_encryption_enabled
      use_system_assigned_identity      = j.value.use_system_assigned_identity
    }
  }
  public_network_access_enabled = var.public_network_access_enabled
}

module "vm_backup_policies" {
  source = "../tf-azurerm-vm-backup-policy"
  for_each                           = { for vm_backup_policy in var.vm_backup_policies : vm_backup_policy.name => vm_backup_policy }
  name                               = each.key
  resource_group_name                = azurerm_recovery_services_vault.vault.resource_group_name
  recovery_vault_name                = azurerm_recovery_services_vault.vault.name
  timezone                           = each.value.timezone
  policy_type                        = each.value.policy_type
  backup                             = each.value.backup
  retention_daily                    = try(each.value.retention_daily, null)
  retention_weekly                   = try(each.value.retention_weekly, null)
  retention_monthly                  = try(each.value.retention_monthly, null)
  retention_yearly                   = try(each.value.retention_yearly, null)
}
module "monitor_diagnostic_settings" {
  source   = "../tf-azurerm-diagnostic-settings"
  for_each = var.diagnostic_settings != null ? { for diagnostic_setting in var.diagnostic_settings : diagnostic_setting.log_analytics_workspace_name => diagnostic_setting } : {}

  name                                        = format("%s-%s", each.key, "diagnostic-settings")
  log_analytics_workspace_name                = each.key
  log_analytics_workspace_subscription_id     = each.value.log_analytics_workspace_subscription_id
  log_analytics_workspace_resource_group_name = each.value.log_analytics_workspace_resource_group_name
  metrics                                     = each.value.metrics
  logs                                        = each.value.logs
  target_resource_id                          = azurerm_recovery_services_vault.vault.id

  # Pass the provider
  providers = {
    azurerm.logs = azurerm.logs
  }
}

module "monitor_recovery_services_vault_private_endpoints" {
  source   = "../tf-azurerm-privateendpoint"
  for_each = var.private_endpoints != null ? { for private_endpoint in var.private_endpoints : private_endpoint.name => private_endpoint } : {}
  private_service_connection_name             = each.value.private_service_connection_name
  subnet_id                                   = each.value.subnet_id
  private_dns_zone_ids                        = each.value.private_dns_zone_ids
  custom_network_interface_name               = each.value.custom_network_interface_name
  private_endpoint_name                       = each.value.private_endpoint_name
  is_manual_connection                        = each.value.is_manual_connection
  location                                    = var.location
  private_connection_resource_id              = azurerm_recovery_services_vault.vault.id
  resource_group_name                         = each.value.resource_group_name
  tags                                        = var.tags
  subresource_names = each.value.subresource_names  
  depends_on = [
    azurerm_recovery_services_vault.vault
  ]
}