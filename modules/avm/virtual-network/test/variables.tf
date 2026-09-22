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
  description = "CIDR address spaces assigned to the primary test virtual network."
  type        = list(string)
  default     = ["10.250.0.0/16"]

  validation {
    condition     = length(var.address_space) > 0 && alltrue([for cidr in var.address_space : can(cidrhost(cidr, 0))])
    error_message = "Provide at least one valid CIDR address space for the primary virtual network."
  }
}

variable "peer_address_space" {
  description = "CIDR address spaces assigned to the secondary peered test virtual network."
  type        = list(string)
  default     = ["10.251.0.0/16"]

  validation {
    condition     = length(var.peer_address_space) > 0 && alltrue([for cidr in var.peer_address_space : can(cidrhost(cidr, 0))])
    error_message = "Provide at least one valid CIDR address space for the secondary virtual network."
  }
}

variable "dns_servers" {
  description = "Optional custom DNS server IPv4 addresses."
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags applied to the temporary test resources."
  type        = map(string)
  default = {
    environment = "test"
    managedBy   = "terraform"
    purpose     = "virtual-network-module-test"
  }
}
