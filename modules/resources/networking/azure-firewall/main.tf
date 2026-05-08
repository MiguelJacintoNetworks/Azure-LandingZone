resource "azurerm_firewall" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = var.sku_name
  sku_tier            = var.sku_tier
  firewall_policy_id  = var.firewall_policy_id
  tags                = var.tags

  ip_configuration {
    name                 = "default"
    subnet_id            = var.subnet_id
    public_ip_address_id = var.public_ip_address_id
  }
}