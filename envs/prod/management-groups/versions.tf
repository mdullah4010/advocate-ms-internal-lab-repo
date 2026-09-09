terraform {
  required_version = ">= 1.9.0, < 2.0.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }

  # Temporary local state while the Azure Storage backend is private and
  # unreachable from this workstation. State files are excluded from Git.
  backend "local" {
    path = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.deployment_subscription_id
  tenant_id       = var.tenant_id
}
