resource "azurerm_role_assignment" "this" {
  scope                            = var.scope
  principal_id                     = var.principal_id
  role_definition_name             = var.role_definition_name
  role_definition_id               = var.role_definition_id
  description                      = var.description
  principal_type                   = var.principal_type
  skip_service_principal_aad_check = var.skip_service_principal_aad_check
}
