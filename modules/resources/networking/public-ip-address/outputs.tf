output "name" {
  description = "NAME OF THE PUBLIC IP ADDRESS RESOURCE."
  value       = azurerm_public_ip.this.name
}

output "id" {
  description = "RESOURCE ID OF THE PUBLIC IP ADDRESS RESOURCE."
  value       = azurerm_public_ip.this.id
}

output "ip_address" {
  description = "IP ADDRESS OF THE PUBLIC IP ADDRESS RESOURCE."
  value       = azurerm_public_ip.this.ip_address
}