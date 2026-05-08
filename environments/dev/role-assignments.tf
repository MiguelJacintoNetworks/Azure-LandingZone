module "current_user_key_vault_administrator_role_assignment" {
  source = "../../modules/resources/identity/role-assignment"

  principal_id         = data.azurerm_client_config.current.object_id
  role_definition_name = "Key Vault Administrator"
  scope                = module.key_vault.id
}

module "management_virtual_machine_key_vault_secrets_officer_role_assignment" {
  source = "../../modules/resources/identity/role-assignment"

  principal_id         = module.management_virtual_machine.principal_id
  role_definition_name = "Key Vault Secrets Officer"
  scope                = module.key_vault.id
}