module "management_virtual_machine_backup_policy" {
  source = "../../modules/resources/recovery/backup-policy-virtual-machine"

  backup_frequency      = var.backup_policy_backup_frequency
  backup_time           = var.backup_policy_backup_time
  name                  = local.names.backup_policy_virtual_machine
  recovery_vault_name   = module.recovery_services_vault.name
  resource_group_name   = module.monitoring_resource_group.name
  retention_daily_count = var.backup_policy_retention_daily_count
  timezone              = "UTC"
}

module "management_virtual_machine_backup_protection" {
  source = "../../modules/resources/recovery/backup-protected-virtual-machine"

  backup_policy_id    = module.management_virtual_machine_backup_policy.id
  recovery_vault_name = module.recovery_services_vault.name
  resource_group_name = module.monitoring_resource_group.name
  virtual_machine_id  = module.management_virtual_machine.id
}

module "recovery_services_vault" {
  source = "../../modules/resources/recovery/recovery-services-vault"

  immutability_state                   = var.backup_immutability_state
  location                             = var.location
  name                                 = local.names.recovery_services_vault
  public_network_access                = var.backup_public_network_access
  resource_group_id                    = module.monitoring_resource_group.id
  sku                                  = "Standard"
  soft_delete_retention_period_in_days = var.backup_soft_delete_retention_period_in_days
  soft_delete_state                    = var.backup_soft_delete_state
  tags                                 = local.common_tags
}