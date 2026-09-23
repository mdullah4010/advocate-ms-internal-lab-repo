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

variable "security_rules" {
  description = "Security rules created in the test network security group."
  type = map(object({
    access                                     = string
    description                                = optional(string)
    destination_address_prefix                 = optional(string)
    destination_address_prefixes               = optional(set(string))
    destination_application_security_group_ids = optional(set(string))
    destination_port_range                     = optional(string)
    destination_port_ranges                    = optional(set(string))
    direction                                  = string
    name                                       = string
    priority                                   = number
    protocol                                   = string
    source_address_prefix                      = optional(string)
    source_address_prefixes                    = optional(set(string))
    source_application_security_group_ids      = optional(set(string))
    source_port_range                          = optional(string)
    source_port_ranges                         = optional(set(string))
    timeouts = optional(object({
      create = optional(string)
      delete = optional(string)
      read   = optional(string)
      update = optional(string)
    }))
  }))
  default = {
    allow_https_inbound = {
      access                     = "Allow"
      destination_address_prefix = "*"
      destination_port_range     = "443"
      direction                  = "Inbound"
      name                       = "AllowHttpsInbound"
      priority                   = 100
      protocol                   = "Tcp"
      source_address_prefix      = "Internet"
      source_port_range          = "*"
    }
  }
}

variable "tags" {
  description = "Tags applied to the temporary test resources."
  type        = map(string)
  default = {
    environment = "test"
    managedBy   = "terraform"
    purpose     = "network-security-group-module-test"
  }
}