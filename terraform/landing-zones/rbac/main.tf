data "azurerm_management_group" "target" {
  for_each = local.management_group_names

  name = each.value
}

module "role_assignment" {
  source = "../../modules/role-assignment"

  for_each = local.all_role_assignments

  scope                            = data.azurerm_management_group.target[each.value.management_group_name].id
  principal_id                     = each.value.principal_id
  role_definition_name             = each.value.role_definition_name
  role_definition_id               = each.value.role_definition_id
  description                      = each.value.description
  principal_type                   = each.value.principal_type
  skip_service_principal_aad_check = each.value.skip_service_principal_aad_check
}
