output "id" {
  description = "RESOURCE ID OF THE POLICY SET DEFINITION."
  value       = azurerm_policy_set_definition.this.id
}

output "name" {
  description = "NAME OF THE POLICY SET DEFINITION."
  value       = azurerm_policy_set_definition.this.name
}