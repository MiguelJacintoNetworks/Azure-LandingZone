output "name" {
  description = "NAME OF THE PRIVATE ENDPOINT."
  value       = azurerm_private_endpoint.this.name
}

output "id" {
  description = "RESOURCE ID OF THE PRIVATE ENDPOINT."
  value       = azurerm_private_endpoint.this.id
}

output "network_interface" {
  description = "NETWORK INTERFACE INFORMATION OF THE PRIVATE ENDPOINT."
  value       = azurerm_private_endpoint.this.network_interface
}