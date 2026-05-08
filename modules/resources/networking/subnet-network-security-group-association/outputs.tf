output "id" {
  description = "RESOURCE ID OF THE SUBNET TO NETWORK SECURITY GROUP ASSOCIATION."
  value       = azurerm_subnet_network_security_group_association.this.id
}