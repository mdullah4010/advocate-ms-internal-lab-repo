terraform {
  required_version = ">= 1.9.0, < 2.0.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {
    subscription {
      prevent_cancellation_on_destroy = true
    }
  }

  use_oidc        = true
  subscription_id = var.deployment_subscription_id
  tenant_id       = var.tenant_id
}
