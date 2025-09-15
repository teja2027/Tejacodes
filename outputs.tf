output "name" {
  value       = azurerm_backup_policy_vm.backup_policy_vm.name
  description = "The name of the Recovery Services Vault VM backup policy."
}

output "id" {
  value       = azurerm_backup_policy_vm.backup_policy_vm.id
  description = "The id of the Recovery Services Vault VM backup policy."
}

output "resource_group_name" {
  value       = azurerm_backup_policy_vm.backup_policy_vm.resource_group_name
  description = "The resource_group_name of the Recovery Services Vault VM backup policy."
}

output "backup" {
  value       = azurerm_backup_policy_vm.backup_policy_vm.backup
  description = "The backup configuration of the Recovery Services Vault VM backup policy."
}