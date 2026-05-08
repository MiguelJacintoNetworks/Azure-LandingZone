output "id" {
  description = "RESOURCE ID OF THE ACTION GROUP."
  value       = azurerm_monitor_action_group.this.id
}

output "name" {
  description = "NAME OF THE ACTION GROUP."
  value       = azurerm_monitor_action_group.this.name
}