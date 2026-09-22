variable "name" {
  description = "Optional globally unique management group name or UUID. Azure generates a UUID when omitted. Changing this value replaces the resource."
  type        = string
  default     = null

  validation {
    condition     = var.name == null || can(regex("^[a-zA-Z0-9_().-]{1,90}$", var.name))
    error_message = "Management group name must contain 1 to 90 ASCII letters, digits, underscores, parentheses, periods, or hyphens."
  }
}

variable "display_name" {
  description = "Optional human-readable management group display name. When omitted, Azure uses the management group name."
  type        = string
  default     = null

  validation {
    condition     = var.display_name == null || length(trimspace(var.display_name)) > 0
    error_message = "Display name must be null or contain at least one non-whitespace character."
  }
}

variable "parent_management_group_id" {
  description = "Optional full resource ID of the parent management group. When omitted, Azure uses the tenant root management group."
  type        = string
  default     = null

  validation {
    condition     = var.parent_management_group_id == null || can(regex("^/providers/Microsoft\\.Management/managementGroups/[^/]+$", var.parent_management_group_id))
    error_message = "Parent must be null or a full management group resource ID."
  }
}

variable "subscription_ids" {
  description = "Optional set of subscription GUIDs assigned to the management group. Set this to an empty set to remove all subscriptions. Do not use with azurerm_management_group_subscription_association for the same subscriptions."
  type        = set(string)
  default     = null

  validation {
    condition = var.subscription_ids == null || alltrue([
      for subscription_id in var.subscription_ids :
      can(regex("^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$", subscription_id))
    ])
    error_message = "Each subscription ID must be a valid GUID."
  }
}

variable "timeouts" {
  description = "Timeouts for management group create, read, update, and delete operations."
  type = object({
    create = optional(string, "30m")
    read   = optional(string, "5m")
    update = optional(string, "30m")
    delete = optional(string, "30m")
  })
  default  = {}
  nullable = false
}
