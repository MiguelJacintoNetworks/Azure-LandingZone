resource "azurerm_key_vault_secret" "this" {
  name         = var.name
  value        = var.value
  key_vault_id = var.key_vault_id

  content_type    = var.content_type
  expiration_date = var.expiration_date
  not_before_date = var.not_before_date

  tags = var.tags
}