resource "azurerm_policy_set_definition" "this" {
  name         = var.name
  display_name = var.display_name
  description  = var.description
  policy_type  = var.policy_type
  metadata     = var.metadata

  dynamic "policy_definition_reference" {
    for_each = var.policy_definitions

    content {
      policy_definition_id = policy_definition_reference.value.policy_definition_id
      reference_id         = policy_definition_reference.value.reference_id
      parameter_values     = try(policy_definition_reference.value.parameter_values, null)
    }
  }
}