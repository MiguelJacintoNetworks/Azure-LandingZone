resource "azurerm_backup_policy_vm" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  recovery_vault_name = var.recovery_vault_name

  timezone = var.timezone

  backup {
    frequency = var.backup_frequency
    time      = var.backup_time
  }

  retention_daily {
    count = var.retention_daily_count
  }
}