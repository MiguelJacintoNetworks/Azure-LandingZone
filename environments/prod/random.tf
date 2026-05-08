resource "random_string" "key_vault_suffix" {
  length  = 6
  numeric = true
  special = false
  upper   = false
}

resource "random_string" "storage_account_suffix" {
  length  = 5
  numeric = true
  special = false
  upper   = false
}