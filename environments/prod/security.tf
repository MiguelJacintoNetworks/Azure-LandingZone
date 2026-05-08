module "key_vault" {
  source = "../../modules/resources/security/key-vault"

  location                      = var.location
  name                          = local.names.key_vault
  public_network_access_enabled = false
  purge_protection_enabled      = true
  resource_group_name           = module.hub_resource_group.name
  sku_name                      = "standard"
  soft_delete_retention_days    = 90
  tags                          = local.common_tags
  tenant_id                     = data.azurerm_client_config.current.tenant_id
}

module "key_vault_private_dns_zone" {
  source = "../../modules/resources/networking/private-dns-zone"

  name                = local.names.key_vault_private_dns_zone
  resource_group_name = module.hub_resource_group.name
  tags                = local.common_tags
}

module "key_vault_private_dns_zone_link_hub" {
  source = "../../modules/resources/networking/private-dns-zone-virtual-network-link"

  name                  = local.names.key_vault_private_dns_zone_link_hub
  private_dns_zone_name = module.key_vault_private_dns_zone.name
  registration_enabled  = false
  resource_group_name   = module.hub_resource_group.name
  tags                  = local.common_tags
  virtual_network_id    = module.hub_virtual_network.id
}

module "key_vault_private_dns_zone_link_management" {
  source = "../../modules/resources/networking/private-dns-zone-virtual-network-link"

  name                  = local.names.key_vault_private_dns_zone_link_management
  private_dns_zone_name = module.key_vault_private_dns_zone.name
  registration_enabled  = false
  resource_group_name   = module.hub_resource_group.name
  tags                  = local.common_tags
  virtual_network_id    = module.management_virtual_network.id
}

module "key_vault_private_dns_zone_link_workload" {
  source = "../../modules/resources/networking/private-dns-zone-virtual-network-link"

  name                  = local.names.key_vault_private_dns_zone_link_workload
  private_dns_zone_name = module.key_vault_private_dns_zone.name
  registration_enabled  = false
  resource_group_name   = module.hub_resource_group.name
  tags                  = local.common_tags
  virtual_network_id    = module.workload_virtual_network.id
}

module "key_vault_private_endpoint" {
  source = "../../modules/resources/networking/private-endpoint"

  location                        = var.location
  name                            = local.names.key_vault_private_endpoint
  private_connection_resource_id  = module.key_vault.id
  private_dns_zone_group_name     = "default"
  private_dns_zone_ids            = [module.key_vault_private_dns_zone.id]
  private_service_connection_name = "psc-kv-${var.environment}"
  resource_group_name             = module.hub_resource_group.name
  subnet_id                       = module.hub_virtual_network.subnet_ids.private_endpoints
  subresource_names               = ["vault"]
  tags                            = local.common_tags
}