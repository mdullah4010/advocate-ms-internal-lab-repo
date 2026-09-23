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
  description = "Azure region for the test resources."
  type        = string
  default     = "westus3"
}

variable "test_run_id" {
  description = "Unique identifier appended to temporary resource names."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9-]+$", var.test_run_id))
    error_message = "Test run ID may contain only letters, numbers, and hyphens."
  }
}

variable "address_space" {
  description = "Address space for the private DNS test virtual network."
  type        = list(string)
  default     = ["10.253.0.0/16"]

  validation {
    condition     = length(var.address_space) > 0 && alltrue([for address in var.address_space : can(cidrnetmask(address))])
    error_message = "At least one valid CIDR address prefix must be provided."
  }
}

variable "virtual_network_link_resolution_policy_default" {
  description = "Default resolution policy for the private DNS zone virtual network link."
  type        = string
  default     = "Default"

  validation {
    condition     = contains(["Default", "NxDomainRedirect"], var.virtual_network_link_resolution_policy_default)
    error_message = "Resolution policy must be Default or NxDomainRedirect."
  }
}

variable "tags" {
  description = "Tags applied to the temporary test resources."
  type        = map(string)
  default = {
    environment = "test"
    managedBy   = "terraform"
    purpose     = "private-dns-zones-module-test"
  }
}