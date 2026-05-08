module "hub_resource_group" {
  source = "../../modules/resources/shared/resource-group"

  location = var.location
  name     = local.names.hub_resource_group
  tags     = local.common_tags
}

module "management_resource_group" {
  source = "../../modules/resources/shared/resource-group"

  location = var.location
  name     = local.names.management_resource_group
  tags     = local.common_tags
}

module "monitoring_resource_group" {
  source = "../../modules/resources/shared/resource-group"

  location = var.location
  name     = local.names.monitoring_resource_group
  tags     = local.common_tags
}

module "workload_resource_group" {
  source = "../../modules/resources/shared/resource-group"

  location = var.location
  name     = local.names.workload_resource_group
  tags     = local.common_tags
}