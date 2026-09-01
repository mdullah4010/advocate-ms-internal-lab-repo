variable "tenant_id" {
  description = "Microsoft Entra tenant ID."
  type        = string
}

variable "deployment_subscription_id" {
  description = "Subscription used to configure the AzureRM provider."
  type        = string
}

variable "hierarchy_role_assignments" {
  description = "Standard assignments at landing-zone root or intermediate management-group scopes."
  type = map(object({
    management_group_name            = string
    principal_id                     = string
    role_definition_name             = optional(string)
    role_definition_id               = optional(string)
    description                      = string
    principal_type                   = optional(string)
    skip_service_principal_aad_check = optional(bool, false)
  }))
  default = {}

  validation {
    condition = alltrue([
      for assignment in values(var.hierarchy_role_assignments) :
      (assignment.role_definition_name == null) != (assignment.role_definition_id == null)
    ])
    error_message = "Each hierarchy assignment must set exactly one of role_definition_name or role_definition_id."
  }
}

variable "role_assignments" {
  description = "Assignments for specific management groups, keyed by a stable semantic name."
  type = map(object({
    management_group_name            = string
    principal_id                     = string
    role_definition_name             = optional(string)
    role_definition_id               = optional(string)
    description                      = string
    principal_type                   = optional(string)
    skip_service_principal_aad_check = optional(bool, false)
  }))
  default = {}

  validation {
    condition = alltrue([
      for assignment in values(var.role_assignments) :
      (assignment.role_definition_name == null) != (assignment.role_definition_id == null)
    ])
    error_message = "Each assignment must set exactly one of role_definition_name or role_definition_id."
  }
}

check "unique_assignment_keys" {
  assert {
    condition     = length(setintersection(toset(keys(var.hierarchy_role_assignments)), toset(keys(var.role_assignments)))) == 0
    error_message = "Assignment keys must be unique across hierarchy_role_assignments and role_assignments."
  }
}
