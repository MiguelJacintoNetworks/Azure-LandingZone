resource "azurerm_security_center_contact" "this" {
  name                = var.name
  email               = var.email
  phone               = trimspace(var.phone) != "" ? trimspace(var.phone) : null
  alert_notifications = var.alert_notifications
  alerts_to_admins    = var.alerts_to_admins
}