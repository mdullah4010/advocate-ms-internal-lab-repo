module "advocate" {
  source = "../../modules/management-group"

  name                       = var.management_group_prefix
  display_name               = "Advocate"
  parent_management_group_id = var.parent_management_group_id
}

module "top_level" {
  source = "../../modules/management-group"

  for_each = {
    platform       = "Platform"
    workloads      = "Workloads"
    consolidation  = "Consolidation"
    sandbox        = "Sandbox"
    decommissioned = "Decommissioned"
  }

  name                       = "${var.management_group_prefix}-${each.key}"
  display_name               = each.value
  parent_management_group_id = module.advocate.id
}

module "platform_child" {
  source = "../../modules/management-group"

  for_each = local.platform_children

  name                       = "${var.management_group_prefix}-${each.key}"
  display_name               = each.value
  parent_management_group_id = module.top_level["platform"].id
}

module "workload_environment" {
  source = "../../modules/management-group"

  for_each = {
    production     = "Production"
    non-production = "Non-Production"
  }

  name                       = "${var.management_group_prefix}-${each.key}"
  display_name               = each.value
  parent_management_group_id = module.top_level["workloads"].id
}

module "production_category" {
  source = "../../modules/management-group"

  for_each = local.workload_categories

  name                       = "${var.management_group_prefix}-prod-${each.key}"
  display_name               = each.value
  parent_management_group_id = module.workload_environment["production"].id
}

module "nonproduction_category" {
  source = "../../modules/management-group"

  for_each = local.workload_categories

  name                       = "${var.management_group_prefix}-nonprod-${each.key}"
  display_name               = each.value
  parent_management_group_id = module.workload_environment["non-production"].id
}

module "consolidation_child" {
  source = "../../modules/management-group"

  for_each = local.consolidation_children

  name                       = "${var.management_group_prefix}-${each.key}"
  display_name               = each.value
  parent_management_group_id = module.top_level["consolidation"].id
}

module "consolidation_environment" {
  source = "../../modules/management-group"

  for_each = local.consolidation_environments

  name                       = "${var.management_group_prefix}-${each.key}"
  display_name               = each.value.display_name
  parent_management_group_id = module.consolidation_child[each.value.tenant].id
}
