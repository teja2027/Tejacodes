variable "vault_name" {
  type        = string
  description = "The name of the Azure Recovery Services Vault."
  validation {
    condition     = (length(var.vault_name) > 2 && length(var.vault_name) < 50 && can(regex("^[a-zA-Z]+[a-zA-Z0-9-]+$", var.vault_name)))
    error_message = "The vault_name must be 2 - 50 characters long, start with a letter, contain only letters, numbers and hyphens."
  }
}
variable "resource_group_name" {
  type        = string
  description = "The name of the Resource Group in which the Storage Account is created."
}
variable "location" {
  type        = string
  description = "The location/region where the resource will be created."
}
variable "sku" {
  type        = string
  description = "Sets the vaults SKU. Possible values include: Standard, RS0"
}
variable "storage_mode_type" {
  type        = string
  description = "The storage type of the Recovery Services Vault. Possible values are GeoRedundant, LocallyRedundant and ZoneRedundant. Defaults to GeoRedundant."
}
variable "cross_region_restore_enabled" {
  type        = bool
  default     = false
  description = "Is cross region restore enabled for this Vault? Only can be true, when storage_mode_type is GeoRedundant. Defaults to false."
}
variable "soft_delete_enabled" {
  type        = bool
  default     = true
  description = "Is soft delete enable for this Vault? Defaults to true."
}
variable "public_network_access_enabled" {
  type        = bool
  default     = true
  description = "Is it enabled to access the vault from public networks? Defaults to true."
}
variable "identity" {
  type = object({
    type = string
  })
  description = <<-EOT
  The schema for identity should look like this:
  ```
  [{
    type         = string       - (Required) Specifies the type of Managed Service Identity that should be configured on this Recovery Services Vault. The only possible value is SystemAssigned.
  }]
  ```
  **NOTE**: When type is set to SystemAssigned, identity the Principal ID can be retrieved after the vault has been created.
  EOT
  default = null
}
variable "encryption" {
  type = object({
    key_id                            = string
    infrastructure_encryption_enabled = bool
    use_system_assigned_identity      = bool
  })
  description = <<-EOT
  The schema for identity should look like this:
  ```
  [{
    key_id                            = string       - (Required) The Key Vault key id used to encrypt this vault. Key managed by Vault Managed Hardware Security Module is also supported.
    infrastructure_encryption_enabled = bool         - (Required) Enabling/Disabling the Double Encryption state.
    use_system_assigned_identity      = bool         - (Optional) Indicate that system assigned identity should be used or not. At this time the only possible value is true. Defaults to true.
  }]
  ```
  **NOTE**: When type is set to SystemAssigned, the Principal ID can be retrieved after the vault has been created.
  EOT
  default = null
}
variable "tags" {
  type        = map(string)
  description = "A map of tags to assign to the resource."
}
# ==================== #
# LOG ANALYTICS 
# ==================== #
variable "monitor_diagnostic_settings_name" {
  type        = string
  description = "The ID of the subscription to assocaite to the Firewall."
  default     = null
}
variable "log_analytics_workspace_subscription_id" {
  type        = string
  description = "The ID of the subscription to assocaite to the Firewall."
  default     = null
}
variable "log_analytics_workspace_resource_group_name" {
  type        = string
  description = "The ID of the subscription to assocaite to the Firewall."
  default     = null
}
variable "log_analytics_workspace_name" {
  type        = string
  description = "The ID of the subscription to assocaite to the Firewall."
  default     = null
}
# ==================== #
# VM BACKUP POLICY
# ==================== #
variable "vm_backup_policies" {
  description = "List of virtual machine backup policies to be applied to the recovery services vault."
  default = null
}


# ============================ #
# PRIVATE Endpoints VARIABLE
# ============================ #

# ==================== #
# COMMON VARIABLES
# ==================== #
variable "common_vars" {
  description = "Common configuration variables used across the module."
  default     = null
}
variable "diagnostic_settings" {
  description = "Settings for configuring diagnostic settings in Azure."

  type = list(object({
    log_analytics_workspace_name                = string
    log_analytics_workspace_subscription_id     = string
    log_analytics_workspace_resource_group_name = string

    metrics = list(object({
      category = string
      enabled  = bool
      retention_policy = optional(object({
        enabled = bool
        days    = optional(number, null)
      }), null)
    }))

    logs = list(object({
      category = string
      category_group = optional(string, null)
      retention_policy = optional(object({
        enabled = bool
        days    = optional(number, null)
      }), null)
    }))
  }))
}
variable "private_endpoints" {
  description = "List of private endpoint configurations for the Key Vault"
  type = list(object({
    name                                 = string
    resource_group_name                  = string
    private_service_connection_name      = string
    is_manual_connection                 = bool
    subnet_id                            = string
    subresource_names                    = list(string)
    private_dns_zone_ids                 = list(string)
    custom_network_interface_name        = string
    private_endpoint_name                = string
  }))
}