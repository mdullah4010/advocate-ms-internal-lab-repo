variable "resource_group_name" {
  description = "Name of the resource group created by the bootstrap deployment."
  type        = string
}

variable "location" {
  description = "Azure region name for the bootstrap resource group, such as eastus2."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]+$", var.location))
    error_message = "Use the Azure region name, such as eastus2, not the display name."
  }
}
