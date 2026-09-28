output "name" {
  description = "Generated resource name."
  value       = local.generated_name

  precondition {
    condition     = length(local.generated_name) >= local.constraint.min && length(local.generated_name) <= local.constraint.max
    error_message = "Generated ${var.resource_type} name '${local.generated_name}' must contain ${local.constraint.min} to ${local.constraint.max} characters. Shorten approved workload or purpose tokens, or use a documented service exception."
  }

  precondition {
    condition     = can(regex(local.constraint.pattern, local.generated_name))
    error_message = "Generated ${var.resource_type} name '${local.generated_name}' does not satisfy the resource's allowed-character or boundary rules."
  }
}

output "abbreviation" {
  description = "Approved resource abbreviation used in the generated name."
  value       = local.abbreviation
}

output "tokens" {
  description = "Ordered tokens used by the selected naming pattern."
  value = var.resource_type == "management_group" ? [var.org_code, var.workload] : (
    var.resource_type == "resource_group" ? local.resource_group_tokens : local.standard_tokens
  )
}

output "is_constrained" {
  description = "Whether the generated name uses a separator-free constrained pattern."
  value       = contains(["container_registry", "storage_account"], var.resource_type)
}

output "max_length" {
  description = "Maximum supported length for the selected resource type."
  value       = local.constraint.max
}
