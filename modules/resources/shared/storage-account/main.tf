resource "azurerm_storage_account" "this" {
  name                     = var.name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type

  public_network_access_enabled = var.public_network_access_enabled
  shared_access_key_enabled     = var.shared_access_key_enabled

  min_tls_version                 = var.min_tls_version
  allow_nested_items_to_be_public = var.allow_nested_items_to_be_public

  tags = var.tags
}