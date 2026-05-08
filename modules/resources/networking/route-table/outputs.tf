output "id" {
  description = "RESOURCE ID OF THE ROUTE TABLE."
  value       = azurerm_route_table.this.id
}

output "name" {
  description = "NAME OF THE ROUTE TABLE."
  value       = azurerm_route_table.this.name
}