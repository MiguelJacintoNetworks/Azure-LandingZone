output "id" {
  description = "RESOURCE ID OF THE VIRTUAL NETWORK PEERING."
  value       = azurerm_virtual_network_peering.this.id
}

output "name" {
  description = "NAME OF THE VIRTUAL NETWORK PEERING."
  value       = azurerm_virtual_network_peering.this.name
}