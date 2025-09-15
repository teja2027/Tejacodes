/**
  * ## Descriptions
  * 
  * Terraform module for the creation of a Azure Recovery Service VM backup policy.
  *
  */

resource "azurerm_backup_policy_vm" "backup_policy_vm" {
  name                           = var.name
  resource_group_name            = var.resource_group_name
  recovery_vault_name            = var.recovery_vault_name
  policy_type                    = var.policy_type
  timezone                       = var.timezone
  instant_restore_retention_days = var.instant_restore_retention_days

  dynamic "backup" {
    for_each = var.backup != null ? [var.backup] : []

    content {
      frequency     = backup.value.frequency
      time          = backup.value.time
      hour_interval = backup.value.hour_interval
      hour_duration = backup.value.hour_duration
      weekdays      = backup.value.weekdays
    }
  }

  dynamic "retention_daily" {
    for_each = var.retention_daily != null ? [var.retention_daily] : []

    content {
      count = retention_daily.value.count
    }
  }

  dynamic "retention_weekly" {
    for_each = var.retention_weekly != null ? [var.retention_weekly] : []

    content {
      count    = retention_weekly.value.count
      weekdays = retention_weekly.value.weekdays
    }
  }

  dynamic "retention_monthly" {
    for_each = var.retention_monthly != null ? [var.retention_monthly] : []

    content {
      count    = retention_monthly.value.count
      weekdays = retention_monthly.value.weekdays
      weeks    = retention_monthly.value.weeks
    }
  }

  dynamic "retention_yearly" {
    for_each = var.retention_yearly != null ? [var.retention_yearly] : []

    content {
      count    = retention_yearly.value.count
      weekdays = retention_yearly.value.weekdays
      weeks    = retention_yearly.value.weeks
      months   = retention_yearly.value.months
    }
  }
}