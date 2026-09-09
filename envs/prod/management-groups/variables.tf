variable "tenant_id" {
  description = "Microsoft Entra tenant ID."
  type        = string
}

variable "deployment_subscription_id" {
  description = "Subscription used to configure the AzureRM provider."
  type        = string
}

variable "parent_management_group_id" {
  description = "Full resource ID of the existing parent management group."
  type        = string

  validation {
    condition     = can(regex("^/providers/Microsoft.Management/managementGroups/[^/]+$", var.parent_management_group_id))
    error_message = "Parent must be a full management group resource ID."
  }
}

variable "management_group_prefix" {
  description = "Stable prefix for all Advocate management group IDs."
  type        = string
  default     = "advocate"

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9-]{0,88}[a-z0-9]$|^[a-z0-9]$", var.management_group_prefix))
    error_message = "Prefix must contain only lowercase letters, numbers, or hyphens and cannot start or end with a hyphen."
  }
}
