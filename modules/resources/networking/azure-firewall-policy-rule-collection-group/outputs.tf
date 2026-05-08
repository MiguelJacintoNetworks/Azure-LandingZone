output "id" {
  description = "RESOURCE ID OF THE AZURE FIREWALL POLICY RULE COLLECTION GROUP."
  value       = azurerm_firewall_policy_rule_collection_group.this.id
}

output "name" {
  description = "NAME OF THE AZURE FIREWALL POLICY RULE COLLECTION GROUP."
  value       = azurerm_firewall_policy_rule_collection_group.this.name
}