variable "name" {
  type        = string
  description = "Specifies the name of the Backup Policy."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the policy."
}

variable "recovery_vault_name" {
  type        = string
  description = "Specifies the name of the Recovery Services Vault to use."
}

variable "policy_type" {
  type        = string
  description = "Type of the Backup Policy. Possible values are `V1` and `V2` where `V2` stands for the Enhanced Policy."
  default     = "V1"
}

variable "timezone" {
  type        = string
  description = "Specifies the timezone. the possible values are defined [here](https://jackstromberg.com/2017/01/list-of-time-zones-consumed-by-azure/)."
  default     = "UTC"
}

variable "instant_restore_retention_days" {
  type        = string
  description = "Specifies the instant restore retention range in days. Possible values are between `1` and `5` when policy_type is `V1`, and `1` to `30` when policy_type is `V2`."
  default     = null
}

variable "backup" {
  type = object({
    frequency     = string
    time          = string
    hour_interval = string
    hour_duration = string
    weekdays      = list(string)
  })

  description = <<-EOT
    Configures the Policy backup frequency, times & days as documented in the backup block below:

    ```
    {
      frequency     = string       - (Required) Sets the backup frequency. Possible values are `Hourly`, `Daily` and `Weekly`.
      time          = string       - (Required) The time of day to perform the backup in 24hour format.
      hour_interval = string       - (Optional) Interval in hour at which backup is triggered. Possible values are `4`, `6`, `8` and `12`. This is used when frequency is Hourly.
      hour_duration = string       - (Optional) Duration of the backup window in hours. Possible values are between `4` and `24` This is used when frequency is Hourly.
      weekdays      = list(string) - (Optional) The days of the week to perform backups on. Must be one of `Sunday`, `Monday`, `Tuesday`, `Wednesday`, `Thursday`, `Friday` or `Saturday`. This is used when `frequency` is `Weekly`.
    }
    ```
  EOT
}

variable "retention_daily" {
  type = object({
    count = number
  })

  description = <<-EOT
    Configures the policy daily retention. Required when backup frequency is `Daily`.

    retention_daily has the following schema:

    ```
    {
      count = number - (Required) The number of daily backups to keep. Must be between `7` and `9999`.
    }
    ```
  EOT

  default = null
}

variable "retention_weekly" {
  type = object({
    count    = number
    weekdays = list(string)
  })

  description = <<-EOT
    Configures the policy weekly retention. Required when backup frequency is `Weekly`.

    retention_weekly has the following schema:

    ```
    {
      count    = number       - (Required) The number of weekly backups to keep. Must be between `1` and `9999`.
      weekdays = list(string) - (Required) The weekday backups to retain. Must be one of `Sunday`, `Monday`, `Tuesday`, `Wednesday`, `Thursday`, `Friday` or `Saturday`.
    }
    ```
  EOT

  default = null
}

variable "retention_monthly" {
  type = object({
    count    = number
    weekdays = list(string)
    weeks    = list(string)
  })

  description = <<-EOT
    Configures the policy monthly retention.

    retention_monthly has the following schema:

    ```
    {
      count    = number       - (Required) The number of monthly backups to keep. Must be between `1` and `9999`.
      weekdays = list(string) - (Required) The weekday backups to retain . Must be one of `Sunday`, `Monday`, `Tuesday`, `Wednesday`, `Thursday`, `Friday` or `Saturday`.
      weeks    = list(string) - (Required) The weeks of the month to retain backups of. Must be one of `First`, `Second`, `Third`, `Fourth`, `Last`.
    }
    ```
  EOT

  default = null
}

variable "retention_yearly" {
  type = object({
    count    = number
    weekdays = list(string)
    weeks    = list(string)
    months   = list(string)
  })

  description = <<-EOT
    Configures the policy yearly retention.

    retention_yearly has the following schema:

    ```
    {
      count    = number       - (Required) The number of monthly backups to keep. Must be between `1` and `9999`.
      weekdays = list(string) - (Required) The weekday backups to retain . Must be one of `Sunday`, `Monday`, `Tuesday`, `Wednesday`, `Thursday`, `Friday` or `Saturday`.
      weeks    = list(string) - (Required) The weeks of the month to retain backups of. Must be one of `First`, `Second`, `Third`, `Fourth`, `Last`.
      months   = list(string) - (Required) The months of the year to retain backups of. Must be one of `January`, `February`, `March`, `April`, `May`, `June`, `July`, `August`, `September`, `October`, `November` and `December`.
    }
    ```
  EOT

  default = null
}
