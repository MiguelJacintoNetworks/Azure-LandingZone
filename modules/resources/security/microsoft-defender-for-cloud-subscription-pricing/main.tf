resource "azurerm_security_center_subscription_pricing" "this" {
  tier          = var.tier
  resource_type = var.resource_type
  subplan       = var.subplan
}