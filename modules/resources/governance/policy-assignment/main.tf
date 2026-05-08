resource "azurerm_subscription_policy_assignment" "this" {
  name                 = var.name
  subscription_id      = local.normalized_subscription_id
  policy_definition_id = var.policy_definition_id
  display_name         = var.display_name
  description          = var.description
  metadata             = var.metadata
}