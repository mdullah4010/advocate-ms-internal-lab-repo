variable "name" {
  description = "Name of the Azure resource group."
  type        = string

  validation {
    condition     = length(trimspace(var.name)) >= 1 && length(var.name) <= 90
    error_message = "Resource group name must contain between 1 and 90 characters."
  }
}

variable "location" {
  description = "Azure region for the resource group."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]+$", var.location))
    error_message = "Location must be an Azure region name without spaces."
  }
}

variable "tags" {
  description = "Tags applied to the resource group."
  type        = map(string)
  default     = {}
}
