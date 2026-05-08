output "id" {
  description = "RESOURCE ID OF THE AZURE FIREWALL POLICY."
  value       = azurerm_firewall_policy.this.id
}

output "name" {
  description = "NAME OF THE AZURE FIREWALL POLICY."
  value       = azurerm_firewall_policy.this.name
}