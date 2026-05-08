output "id" {
  description = "RESOURCE ID OF THE DATA COLLECTION RULE."
  value       = azurerm_monitor_data_collection_rule.this.id
}

output "name" {
  description = "NAME OF THE DATA COLLECTION RULE."
  value       = azurerm_monitor_data_collection_rule.this.name
}