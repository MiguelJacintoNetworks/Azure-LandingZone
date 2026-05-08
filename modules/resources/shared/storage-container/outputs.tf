output "name" {
  description = "NAME OF THE STORAGE CONTAINER."
  value       = azurerm_storage_container.this.name
}

output "id" {
  description = "RESOURCE ID OF THE STORAGE CONTAINER."
  value       = azurerm_storage_container.this.id
}