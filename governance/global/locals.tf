locals {
  common_tags = merge(
    var.default_tags,
    {
      environment = var.environment
      workload    = var.workload_name
      managed_by  = "terraform"
    }
  )

  normalized_required_tag_names = sort(distinct(var.required_tag_names))

  target_subscription_id = var.target_subscription_id != null ? var.target_subscription_id : data.azurerm_client_config.current.subscription_id
  target_scope_id        = "/subscriptions/${local.target_subscription_id}"

  names = {
    policy_allowed_locations             = "pd-allowed-locations-${var.environment}"
    policy_allowed_rg_locations          = "pd-allowed-rg-locations-${var.environment}"
    policy_audit_required_resource_tags  = "pd-audit-resource-tags-${var.environment}"
    policy_audit_required_rg_tags        = "pd-audit-rg-tags-${var.environment}"
    policy_audit_storage_public_access   = "pd-audit-storage-pna-${var.environment}"
    policy_audit_key_vault_public_access = "pd-audit-kv-pna-${var.environment}"

    policy_set_definition_baseline = "psd-${var.resource_prefix}-${var.workload_name}-${var.environment}"
    policy_assignment_baseline     = "pa-${var.resource_prefix}-${var.workload_name}-baseline-${var.environment}"

    defender_security_contact = "default"
  }

  entra_group_names = {
    platform_admins   = "grp-${var.resource_prefix}-platform-admins-${var.environment}"
    platform_readers  = "grp-${var.resource_prefix}-platform-readers-${var.environment}"
    security_auditors = "grp-${var.resource_prefix}-security-auditors-${var.environment}"
  }
}

locals {
  identity_groups = {
    platform_admins = {
      description          = "PLATFORM ADMINISTRATORS FOR THE AZURE ADMINISTRATION LANDING ZONE."
      display_name         = local.entra_group_names.platform_admins
      mail_nickname        = replace(local.entra_group_names.platform_admins, "-", "")
      member_object_ids    = var.identity_members.platform_admins
      role_definition_name = var.platform_admin_role_definition_name
    }

    platform_readers = {
      description          = "READ-ONLY PLATFORM OPERATORS FOR THE AZURE ADMINISTRATION LANDING ZONE."
      display_name         = local.entra_group_names.platform_readers
      mail_nickname        = replace(local.entra_group_names.platform_readers, "-", "")
      member_object_ids    = var.identity_members.platform_readers
      role_definition_name = var.platform_reader_role_definition_name
    }

    security_auditors = {
      description          = "SECURITY AUDITORS FOR THE AZURE ADMINISTRATION LANDING ZONE."
      display_name         = local.entra_group_names.security_auditors
      mail_nickname        = replace(local.entra_group_names.security_auditors, "-", "")
      member_object_ids    = var.identity_members.security_auditors
      role_definition_name = var.security_auditor_role_definition_name
    }
  }

  enabled_identity_groups = var.enable_entra_groups ? local.identity_groups : {}
}

locals {
  defender_for_servers_pricing_configs = var.enable_defender_for_cloud && var.enable_defender_for_servers ? {
    virtual_machines = {
      resource_type = "VirtualMachines"
      subplan       = var.defender_for_servers_subplan
      tier          = "Standard"
    }
  } : {}

  defender_security_contact_configs = var.enable_defender_for_cloud && trimspace(var.defender_security_contact_email) != "" ? {
    default = {
      name = local.names.defender_security_contact
    }
  } : {}
}