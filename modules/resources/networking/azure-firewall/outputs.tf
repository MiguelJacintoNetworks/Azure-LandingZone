output "id" {
  description = "RESOURCE ID OF THE AZURE FIREWALL."
  value       = azurerm_firewall.this.id
}

output "name" {
  description = "NAME OF THE AZURE FIREWALL."
  value       = azurerm_firewall.this.name
}

output "private_ip_address" {
  description = "PRIVATE IP ADDRESS OF THE AZURE FIREWALL."
  value       = azurerm_firewall.this.ip_configuration[0].private_ip_address
}