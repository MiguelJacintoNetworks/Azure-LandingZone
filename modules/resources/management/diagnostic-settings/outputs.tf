output "id" {
  description = "RESOURCE ID OF THE DIAGNOSTIC SETTING."
  value       = azurerm_monitor_diagnostic_setting.this.id
}

output "name" {
  description = "NAME OF THE DIAGNOSTIC SETTING."
  value       = azurerm_monitor_diagnostic_setting.this.name
}