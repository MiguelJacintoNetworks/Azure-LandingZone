output "id" {
  description = "RESOURCE ID OF THE VIRTUAL MACHINE BACKUP POLICY."
  value       = azurerm_backup_policy_vm.this.id
}

output "name" {
  description = "NAME OF THE VIRTUAL MACHINE BACKUP POLICY."
  value       = azurerm_backup_policy_vm.this.name
}