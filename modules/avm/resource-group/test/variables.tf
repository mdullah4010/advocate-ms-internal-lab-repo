variable "tenant_id" {
  description = "Microsoft Entra tenant ID used for the test deployment."
  type        = string

  validation {
    condition     = can(regex("^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$", var.tenant_id))
    error_message = "Tenant ID must be a GUID."
  }
}

variable "subscription_id" {
  description = "Azure subscription ID used for the test deployment."
  type        = string

  validation {
    condition     = can(regex("^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$", var.subscription_id))
    error_message = "Subscription ID must be a GUID."
  }
}

variable "location" {
  description = "Azure region for the test resource group."
  type        = string
  default     = "westus3"
}

variable "test_run_id" {
  description = "Unique identifier appended to the temporary resource group name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9-]+$", var.test_run_id))
    error_message = "Test run ID may contain only letters, numbers, and hyphens."
  }
}

variable "tags" {
  description = "Tags applied to the temporary test resource group."
  type        = map(string)
  default = {
    environment = "test"
    managedBy   = "terraform"
    purpose     = "resource-group-module-test"
  }
}
