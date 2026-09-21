locals {
  resource_group_name = "rg-module-test-${var.test_run_id}"
}

module "resource_group" {
  source = "./.."

  name     = local.resource_group_name
  location = var.location
  tags     = var.tags
}
