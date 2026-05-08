output "name" {
  description = "NAME OF THE RESOURCE GROUP."
  value       = azurerm_resource_group.this.name
}

output "id" {
  description = "RESOURCE ID OF THE RESOURCE GROUP."
  value       = azurerm_resource_group.this.id
}

output "location" {
  description = "AZURE REGION OF THE RESOURCE GROUP."
  value       = azurerm_resource_group.this.location
}