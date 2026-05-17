module "defender_for_servers_pricing" {
  for_each = local.defender_for_servers_pricing_configs

  source = "../../modules/resources/security/microsoft-defender-for-cloud-subscription-pricing"

  tier          = each.value.tier
  resource_type = each.value.resource_type
  subplan       = each.value.subplan
}

module "defender_security_contact" {
  for_each = local.defender_security_contact_configs

  source = "../../modules/resources/security/microsoft-defender-for-cloud-security-contact"

  name                = each.value.name
  email               = var.defender_security_contact_email
  phone               = var.defender_security_contact_phone
  alert_notifications = var.defender_alert_notifications
  alerts_to_admins    = var.defender_alerts_to_admins
}

import {
  for_each = local.defender_for_servers_pricing_configs
  to       = module.defender_for_servers_pricing[each.key].azurerm_security_center_subscription_pricing.this
  id       = "/subscriptions/${local.target_subscription_id}/providers/Microsoft.Security/pricings/${each.value.resource_type}"
}