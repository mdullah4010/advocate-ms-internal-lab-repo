variable "name" {
  description = "Stable management group ID."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9-]{0,88}[a-z0-9]$|^[a-z0-9]$", var.name))
    error_message = "Management group ID must be 1-90 lowercase letters, numbers, or hyphens and cannot start or end with a hyphen."
  }
}

variable "display_name" {
  description = "Human-readable management group display name."
  type        = string

  validation {
    condition     = length(trimspace(var.display_name)) > 0
    error_message = "Display name cannot be empty."
  }
}

variable "parent_management_group_id" {
  description = "Full resource ID of the parent management group."
  type        = string

  validation {
    condition     = can(regex("^/providers/Microsoft.Management/managementGroups/[^/]+$", var.parent_management_group_id))
    error_message = "Parent must be a full management group resource ID."
  }
}
