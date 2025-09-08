output "recovery_services_vault_id" {
  value       = azurerm_recovery_services_vault.vault.id
  description = "The ID of the Recovery Services Vault."
}

output "vault_name" {
  value       = azurerm_recovery_services_vault.vault.name
  description = "The name of the Recovery Services Vault."
}

output "backup_policy_ids" {
  value       = { for k, v in module.vm_backup_policies : k => v.id }
  description = "The id of the Recovery Services Vault VM backup policy."
}