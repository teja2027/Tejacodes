variable "common_vars" {
  description = "Common variables for the module"
  default = null

  
}
variable "recovery_services_vaults" {
  default = null
}
variable "monitor_diagnostic_shared_settings" {
  default = null

  description = "Shared settings for monitor diagnostic settings"
}