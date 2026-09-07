variable "name" {
  description = "Name of the Azure virtual network."
  type        = string

  validation {
    condition     = length(trimspace(var.name)) >= 2 && length(var.name) <= 64
    error_message = "Virtual network name must contain between 2 and 64 characters."
  }
}

variable "location" {
  description = "Azure region for the virtual network."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group containing the virtual network."
  type        = string
}

variable "address_space" {
  description = "CIDR address spaces assigned to the virtual network."
  type        = list(string)

  validation {
    condition     = length(var.address_space) > 0 && alltrue([for cidr in var.address_space : can(cidrhost(cidr, 0))])
    error_message = "Provide at least one valid CIDR address space."
  }
}

variable "dns_servers" {
  description = "Optional custom DNS server IPv4 addresses."
  type        = list(string)
  default     = []

  validation {
    condition     = alltrue([for address in var.dns_servers : can(cidrhost("${address}/32", 0))])
    error_message = "Each DNS server must be a valid IPv4 address."
  }
}

variable "tags" {
  description = "Tags applied to the virtual network."
  type        = map(string)
  default     = {}
}
