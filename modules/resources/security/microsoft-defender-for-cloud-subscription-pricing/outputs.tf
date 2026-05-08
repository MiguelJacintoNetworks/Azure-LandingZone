output "id" {
  description = "RESOURCE ID OF THE MICROSOFT DEFENDER FOR CLOUD SUBSCRIPTION PRICING CONFIGURATION."
  value       = azurerm_security_center_subscription_pricing.this.id
}

output "resource_type" {
  description = "RESOURCE TYPE OF THE MICROSOFT DEFENDER FOR CLOUD PLAN."
  value       = azurerm_security_center_subscription_pricing.this.resource_type
}