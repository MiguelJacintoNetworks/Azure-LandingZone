output "name" {
  description = "NAME OF THE BASTION HOST."
  value       = azurerm_bastion_host.this.name
}

output "id" {
  description = "RESOURCE ID OF THE BASTION HOST."
  value       = azurerm_bastion_host.this.id
}

output "dns_name" {
  description = "DNS NAME OF THE BASTION HOST."
  value       = azurerm_bastion_host.this.dns_name
}