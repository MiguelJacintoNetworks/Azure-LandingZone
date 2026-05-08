output "id" {
  description = "RESOURCE ID OF THE NETWORK INTERFACE."
  value       = azurerm_network_interface.this.id
}

output "private_ip" {
  description = "PRIVATE IP ADDRESS OF THE NETWORK INTERFACE."
  value       = azurerm_network_interface.this.ip_configuration[0].private_ip_address
}