terraform {
  backend "azurerm" {}

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.116.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "= 3.5.1"
    }
  }
}


# Provider for Log Analytics resources which may be in a different subscription
provider "azurerm" {
  alias           = "logs"
  subscription_id = "b0290594-4a11-4eb6-aae9-ed4860113fd7" # Log Analytics subscription
  features {}
}
provider "azurerm" {
  features {}
  subscription_id            = var.common_vars.subscription_id
  tenant_id                  = var.common_vars.tenant_id
  skip_provider_registration = true

  #Uncomment below lines to use managed identity assigned to VMSS. You will need to pass value for variable msi_client_id from the pipeline.
  #use_msi                    = true
  #client_id                  = var.msi_client_id
}

provider "azurerm" {
  features {}
  alias                      = "connectivity"
  subscription_id            = var.common_vars.remote_subscriptions["connectivity"].subscription_id
  tenant_id                  = var.common_vars.tenant_id
  skip_provider_registration = true

  #Uncomment below lines to use managed identity assigned to VMSS. You will need to pass value for variable msi_client_id from the pipeline.
  #use_msi                    = true
  #client_id                  = var.msi_client_id
}