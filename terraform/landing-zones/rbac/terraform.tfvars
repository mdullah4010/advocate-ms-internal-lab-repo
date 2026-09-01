tenant_id                  = "bd2d48b3-6ed3-4be7-99e7-7d5196dd39ed"
deployment_subscription_id = "544ce6ae-bcad-46bf-9aff-ba1bbda3c7cf"

hierarchy_role_assignments = {
  mdullah_advocate_contributor = {
    management_group_name = "advocate"
    principal_id          = "03ea5dea-254a-4b42-9726-46f1a6046dfd"
    role_definition_name  = "Contributor"
    description           = "Contributor access for mdullah@microsoft.com at the Advocate landing-zone root."
    principal_type        = "User"
  }

  mdullah_platform_contributor = {
    management_group_name = "advocate-platform"
    principal_id          = "03ea5dea-254a-4b42-9726-46f1a6046dfd"
    role_definition_name  = "Contributor"
    description           = "Explicit intermediate-scope Contributor example for mdullah@microsoft.com."
    principal_type        = "User"
  }
}

role_assignments = {
  mdullah_clinical_prod_reader = {
    management_group_name = "advocate-prod-clinical-systems"
    principal_id          = "03ea5dea-254a-4b42-9726-46f1a6046dfd"
    role_definition_name  = "Reader"
    description           = "Specific management-group Reader example for mdullah@microsoft.com."
    principal_type        = "User"
  }
}
