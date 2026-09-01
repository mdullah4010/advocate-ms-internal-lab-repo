variable "scope" {
  description = "Azure resource ID on which to assign the role."
  type        = string
}

variable "principal_id" {
  description = "Microsoft Entra object ID of the group, service principal, or managed identity."
  type        = string

  validation {
    condition     = can(regex("^[0-9a-fA-F-]{36}$", var.principal_id))
    error_message = "Principal ID must be a GUID object ID."
  }
}

variable "role_definition_name" {
  description = "Built-in role name. Set either this or role_definition_id."
  type        = string
  default     = null
}

variable "role_definition_id" {
  description = "Role definition resource ID. Set either this or role_definition_name."
  type        = string
  default     = null
}

variable "description" {
  description = "Purpose of the role assignment."
  type        = string
}

variable "principal_type" {
  description = "Optional principal type: Group, ServicePrincipal, or User."
  type        = string
  default     = null

  validation {
    condition     = var.principal_type == null || contains(["Group", "ServicePrincipal", "User"], var.principal_type)
    error_message = "Principal type must be Group, ServicePrincipal, User, or null."
  }
}

variable "skip_service_principal_aad_check" {
  description = "Skip the Entra replication check for newly created service principals."
  type        = bool
  default     = false
}

check "role_selector" {
  assert {
    condition     = (var.role_definition_name == null) != (var.role_definition_id == null)
    error_message = "Set exactly one of role_definition_name or role_definition_id."
  }
}
