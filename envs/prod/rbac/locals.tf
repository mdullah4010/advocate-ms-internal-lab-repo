locals {
  all_role_assignments = merge(var.hierarchy_role_assignments, var.role_assignments)

  management_group_names = toset([
    for assignment in values(local.all_role_assignments) : assignment.management_group_name
  ])
}
