output "name" {
  description = "NAME OF THE PRIVATE DNS ZONE."
  value       = azurerm_private_dns_zone.this.name
}

output "id" {
  description = "RESOURCE ID OF THE PRIVATE DNS ZONE."
  value       = azurerm_private_dns_zone.this.id
}