output "name" {
  description = "NAME OF THE LOG ANALYTICS WORKSPACE."
  value       = azurerm_log_analytics_workspace.this.name
}

output "id" {
  description = "RESOURCE ID OF THE LOG ANALYTICS WORKSPACE."
  value       = azurerm_log_analytics_workspace.this.id
}

output "workspace_id" {
  description = "WORKSPACE ID OF THE LOG ANALYTICS WORKSPACE."
  value       = azurerm_log_analytics_workspace.this.workspace_id
}