variable "tenant_id" {
  description = "Microsoft Entra tenant ID."
  type        = string

  validation {
    condition     = can(regex("^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$", var.tenant_id))
    error_message = "Tenant ID must be a GUID."
  }
}

variable "subscription_id" {
  description = "Internal Azure subscription in which to deploy the hub network."
  type        = string

  validation {
    condition     = can(regex("^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$", var.subscription_id))
    error_message = "Subscription ID must be a GUID."
  }
}

variable "location" {
  description = "Azure region for the hub network resources."
  type        = string
  default     = "westus3"

  validation {
    condition     = can(regex("^[a-z0-9]+$", var.location))
    error_message = "Location must be an Azure region name without spaces."
  }
}

variable "resource_group_name" {
  description = "Name of the resource group created for hub connectivity resources."
  type        = string

  validation {
    condition     = length(trimspace(var.resource_group_name)) >= 1 && length(var.resource_group_name) <= 90
    error_message = "Resource group name must contain between 1 and 90 characters."
  }
}

variable "hub_virtual_network_name" {
  description = "Name of the hub virtual network."
  type        = string

  validation {
    condition     = length(trimspace(var.hub_virtual_network_name)) >= 2 && length(var.hub_virtual_network_name) <= 64
    error_message = "Virtual network name must contain between 2 and 64 characters."
  }
}

variable "hub_address_space" {
  description = "CIDR address spaces assigned to the hub virtual network."
  type        = list(string)

  validation {
    condition     = length(var.hub_address_space) > 0 && alltrue([for cidr in var.hub_address_space : can(cidrhost(cidr, 0))])
    error_message = "Provide at least one valid CIDR address space."
  }
}

variable "subnets" {
  description = "Hub subnets keyed by subnet name."
  type = map(object({
    address_prefixes                          = list(string)
    private_endpoint_network_policies_enabled = optional(bool, true)
  }))
  default = {}

  validation {
    condition = alltrue(flatten([
      for subnet in values(var.subnets) : [
        for cidr in subnet.address_prefixes : can(cidrhost(cidr, 0))
      ]
    ]))
    error_message = "Every subnet address prefix must be a valid CIDR."
  }

  validation {
    condition     = alltrue([for subnet in values(var.subnets) : length(subnet.address_prefixes) > 0])
    error_message = "Every subnet must contain at least one address prefix."
  }
}

variable "dns_servers" {
  description = "Optional custom DNS server IPv4 addresses. Leave empty to use Azure-provided DNS."
  type        = list(string)
  default     = []

  validation {
    condition     = alltrue([for address in var.dns_servers : can(cidrhost("${address}/32", 0))])
    error_message = "Each DNS server must be a valid IPv4 address."
  }
}

variable "tags" {
  description = "Tags applied to the hub network resources."
  type        = map(string)
  default = {
    managedBy = "terraform"
  }
}
