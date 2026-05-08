output "name" {
  description = "NAME OF THE NETWORK SECURITY GROUP."
  value       = azurerm_network_security_group.this.name
}

output "id" {
  description = "RESOURCE ID OF THE NETWORK SECURITY GROUP."
  value       = azurerm_network_security_group.this.id
}