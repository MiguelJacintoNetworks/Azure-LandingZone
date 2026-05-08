module "entra_groups" {
  for_each = local.enabled_identity_groups

  source = "../../modules/resources/identity/entra-id-group"

  display_name      = each.value.display_name
  description       = each.value.description
  mail_nickname     = each.value.mail_nickname
  member_object_ids = each.value.member_object_ids
}

module "role_assignments" {
  for_each = local.enabled_identity_groups

  source = "../../modules/resources/identity/role-assignment"

  scope                = local.target_scope_id
  role_definition_name = each.value.role_definition_name
  principal_id         = module.entra_groups[each.key].id
}