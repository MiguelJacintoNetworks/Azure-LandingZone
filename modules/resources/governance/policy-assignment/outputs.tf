output "id" {
  description = "RESOURCE ID OF THE POLICY ASSIGNMENT."
  value       = azurerm_subscription_policy_assignment.this.id
}

output "name" {
  description = "NAME OF THE POLICY ASSIGNMENT."
  value       = azurerm_subscription_policy_assignment.this.name
}