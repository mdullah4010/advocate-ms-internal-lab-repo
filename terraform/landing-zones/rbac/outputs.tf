output "role_assignment_ids" {
  description = "Role assignment resource IDs keyed by semantic assignment name."
  value = {
    for key, assignment in module.role_assignment : key => assignment.id
  }
}
