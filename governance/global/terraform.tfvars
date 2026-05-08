location        = "eastus"
environment     = "dev"
resource_prefix = "np"
workload_name   = "network-platform"

default_tags = {
  owner       = "Miguel"
  domain      = "networking"
  cost_center = "lab"
}

allowed_locations = [
  "eastus"
]

required_tag_names = [
  "owner",
  "domain",
  "cost_center",
  "environment",
  "workload",
  "managed_by"
]

allowed_locations_effect     = "Deny"
tag_compliance_effect        = "Audit"
public_network_access_effect = "Audit"

enable_entra_groups = true

identity_members = {
  platform_admins   = []
  platform_readers  = []
  security_auditors = []
}

platform_admin_role_definition_name   = "Contributor"
platform_reader_role_definition_name  = "Reader"
security_auditor_role_definition_name = "Reader"

enable_defender_for_cloud   = true
enable_defender_for_servers = true

defender_security_contact_email = "miguelmazda@gmail.com"
defender_security_contact_phone = ""

defender_alert_notifications = true
defender_alerts_to_admins    = true
defender_for_servers_subplan = "P2"