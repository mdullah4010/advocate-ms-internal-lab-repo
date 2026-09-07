variable "name" {
  description = "Name of the subnet."
  type        = string

  validation {
    condition     = length(trimspace(var.name)) >= 1 && length(var.name) <= 80
    error_message = "Subnet name must contain between 1 and 80 characters."
  }
}

variable "resource_group_name" {
  description = "Name of the resource group containing the virtual network."
  type        = string
}

variable "virtual_network_name" {
  description = "Name of the virtual network containing the subnet."
  type        = string
}

variable "address_prefixes" {
  description = "CIDR address prefixes assigned to the subnet."
  type        = list(string)

  validation {
    condition     = length(var.address_prefixes) > 0 && alltrue([for cidr in var.address_prefixes : can(cidrhost(cidr, 0))])
    error_message = "Provide at least one valid subnet CIDR address prefix."
  }
}

variable "private_endpoint_network_policies_enabled" {
  description = "Whether private endpoint network policies are enabled for the subnet."
  type        = bool
  default     = true
}
