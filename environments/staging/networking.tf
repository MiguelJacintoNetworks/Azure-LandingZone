module "bastion" {
  source = "../../modules/resources/networking/bastion-host"

  location             = var.location
  name                 = local.names.bastion
  public_ip_address_id = module.bastion_public_ip.id
  resource_group_name  = module.hub_resource_group.name
  sku                  = "Basic"
  subnet_id            = module.hub_virtual_network.subnet_ids.bastion
  tags                 = local.common_tags
}

module "bastion_public_ip" {
  source = "../../modules/resources/networking/public-ip-address"

  allocation_method   = "Static"
  location            = var.location
  name                = local.names.public_ip_bastion
  resource_group_name = module.hub_resource_group.name
  sku                 = "Standard"
  tags                = local.common_tags
}

module "blob_private_dns_zone" {
  source = "../../modules/resources/networking/private-dns-zone"

  name                = local.names.blob_private_dns_zone
  resource_group_name = module.hub_resource_group.name
  tags                = local.common_tags
}

module "blob_private_dns_zone_link_hub" {
  source = "../../modules/resources/networking/private-dns-zone-virtual-network-link"

  name                  = local.names.blob_private_dns_zone_link_hub
  private_dns_zone_name = module.blob_private_dns_zone.name
  registration_enabled  = false
  resource_group_name   = module.hub_resource_group.name
  tags                  = local.common_tags
  virtual_network_id    = module.hub_virtual_network.id
}

module "blob_private_dns_zone_link_management" {
  source = "../../modules/resources/networking/private-dns-zone-virtual-network-link"

  name                  = local.names.blob_private_dns_zone_link_management
  private_dns_zone_name = module.blob_private_dns_zone.name
  registration_enabled  = false
  resource_group_name   = module.hub_resource_group.name
  tags                  = local.common_tags
  virtual_network_id    = module.management_virtual_network.id
}

module "blob_private_dns_zone_link_workload" {
  source = "../../modules/resources/networking/private-dns-zone-virtual-network-link"

  name                  = local.names.blob_private_dns_zone_link_workload
  private_dns_zone_name = module.blob_private_dns_zone.name
  registration_enabled  = false
  resource_group_name   = module.hub_resource_group.name
  tags                  = local.common_tags
  virtual_network_id    = module.workload_virtual_network.id
}

module "blob_private_endpoint" {
  source = "../../modules/resources/networking/private-endpoint"

  location                        = var.location
  name                            = local.names.blob_private_endpoint
  private_connection_resource_id  = module.workload_storage_account.id
  private_dns_zone_group_name     = "default"
  private_dns_zone_ids            = [module.blob_private_dns_zone.id]
  private_service_connection_name = "psc-blob-${var.environment}"
  resource_group_name             = module.hub_resource_group.name
  subnet_id                       = module.hub_virtual_network.subnet_ids.private_endpoints
  subresource_names               = ["blob"]
  tags                            = local.common_tags
}

module "firewall" {
  source = "../../modules/resources/networking/azure-firewall"

  firewall_policy_id   = module.firewall_policy.id
  location             = var.location
  name                 = local.names.firewall
  public_ip_address_id = module.firewall_public_ip.id
  resource_group_name  = module.hub_resource_group.name
  sku_name             = var.firewall_sku_name
  sku_tier             = var.firewall_sku_tier
  subnet_id            = module.hub_virtual_network.subnet_ids.firewall
  tags                 = local.common_tags
}

module "firewall_policy" {
  source = "../../modules/resources/networking/azure-firewall-policy"

  location                 = var.location
  name                     = local.names.firewall_policy
  resource_group_name      = module.hub_resource_group.name
  sku                      = var.firewall_policy_sku
  tags                     = local.common_tags
  threat_intelligence_mode = var.firewall_policy_threat_intelligence_mode
}

module "firewall_policy_rule_collection_groups" {
  for_each = local.firewall_policy_rule_collection_groups

  source = "../../modules/resources/networking/azure-firewall-policy-rule-collection-group"

  application_rule_collections = each.value.application_rule_collections
  firewall_policy_id           = module.firewall_policy.id
  name                         = each.value.name
  nat_rule_collections         = each.value.nat_rule_collections
  network_rule_collections     = each.value.network_rule_collections
  priority                     = each.value.priority
}

module "firewall_public_ip" {
  source = "../../modules/resources/networking/public-ip-address"

  allocation_method   = "Static"
  location            = var.location
  name                = local.names.public_ip_firewall
  resource_group_name = module.hub_resource_group.name
  sku                 = "Standard"
  tags                = local.common_tags
}

module "hub_network_security_group" {
  source = "../../modules/resources/networking/network-security-group"

  location            = var.location
  name                = local.names.hub_network_security_group
  resource_group_name = module.hub_resource_group.name
  security_rules      = local.nsg_rules.hub_shared
  tags                = local.common_tags
}

module "hub_shared_subnet_network_security_group_association" {
  source = "../../modules/resources/networking/subnet-network-security-group-association"

  network_security_group_id = module.hub_network_security_group.id
  subnet_id                 = module.hub_virtual_network.subnet_ids.shared
}

module "hub_to_management_virtual_network_peering" {
  source = "../../modules/resources/networking/virtual-network-peering"

  allow_forwarded_traffic      = false
  allow_gateway_transit        = false
  allow_virtual_network_access = true
  name                         = local.names.hub_to_management_peering
  remote_virtual_network_id    = module.management_virtual_network.id
  resource_group_name          = module.hub_resource_group.name
  use_remote_gateways          = false
  virtual_network_name         = module.hub_virtual_network.name
}

module "hub_to_workload_virtual_network_peering" {
  source = "../../modules/resources/networking/virtual-network-peering"

  allow_forwarded_traffic      = false
  allow_gateway_transit        = false
  allow_virtual_network_access = true
  name                         = local.names.hub_to_workload_peering
  remote_virtual_network_id    = module.workload_virtual_network.id
  resource_group_name          = module.hub_resource_group.name
  use_remote_gateways          = false
  virtual_network_name         = module.hub_virtual_network.name
}

module "hub_virtual_network" {
  source = "../../modules/resources/networking/virtual-network"

  address_space       = local.networking_config.hub.address_space
  location            = var.location
  name                = local.names.vnet_hub
  resource_group_name = module.hub_resource_group.name
  subnets             = local.networking_config.hub.subnets
  tags                = local.common_tags
}

module "management_network_security_group" {
  source = "../../modules/resources/networking/network-security-group"

  location            = var.location
  name                = local.names.management_network_security_group
  resource_group_name = module.management_resource_group.name
  security_rules      = local.nsg_rules.management
  tags                = local.common_tags
}

module "management_route_table" {
  source = "../../modules/resources/networking/route-table"

  location            = var.location
  name                = local.names.management_route_table
  resource_group_name = module.management_resource_group.name
  routes = [
    {
      address_prefix         = "0.0.0.0/0"
      name                   = "default-to-firewall"
      next_hop_in_ip_address = module.firewall.private_ip_address
      next_hop_type          = "VirtualAppliance"
    }
  ]
  tags = local.common_tags
}

module "management_subnet_network_security_group_association" {
  source = "../../modules/resources/networking/subnet-network-security-group-association"

  network_security_group_id = module.management_network_security_group.id
  subnet_id                 = module.management_virtual_network.subnet_ids.management
}

module "management_subnet_route_table_association" {
  source = "../../modules/resources/networking/subnet-route-table-association"

  route_table_id = module.management_route_table.id
  subnet_id      = module.management_virtual_network.subnet_ids.management
}

module "management_to_hub_virtual_network_peering" {
  source = "../../modules/resources/networking/virtual-network-peering"

  allow_forwarded_traffic      = false
  allow_gateway_transit        = false
  allow_virtual_network_access = true
  name                         = local.names.management_to_hub_peering
  remote_virtual_network_id    = module.hub_virtual_network.id
  resource_group_name          = module.management_resource_group.name
  use_remote_gateways          = false
  virtual_network_name         = module.management_virtual_network.name
}

module "management_virtual_network" {
  source = "../../modules/resources/networking/virtual-network"

  address_space       = local.networking_config.management.address_space
  location            = var.location
  name                = local.names.vnet_management
  resource_group_name = module.management_resource_group.name
  subnets             = local.networking_config.management.subnets
  tags                = local.common_tags
}

module "workload_network_security_group" {
  source = "../../modules/resources/networking/network-security-group"

  location            = var.location
  name                = local.names.workload_network_security_group
  resource_group_name = module.workload_resource_group.name
  security_rules      = local.nsg_rules.workload
  tags                = local.common_tags
}

module "workload_route_table" {
  source = "../../modules/resources/networking/route-table"

  location            = var.location
  name                = local.names.workload_route_table
  resource_group_name = module.workload_resource_group.name
  routes = [
    {
      address_prefix         = "0.0.0.0/0"
      name                   = "default-to-firewall"
      next_hop_in_ip_address = module.firewall.private_ip_address
      next_hop_type          = "VirtualAppliance"
    }
  ]
  tags = local.common_tags
}

module "workload_storage_account" {
  source = "../../modules/resources/shared/storage-account"

  account_replication_type        = "LRS"
  account_tier                    = "Standard"
  allow_nested_items_to_be_public = false
  location                        = var.location
  min_tls_version                 = "TLS1_2"
  name                            = local.names.storage_account
  public_network_access_enabled   = false
  resource_group_name             = module.workload_resource_group.name
  shared_access_key_enabled       = true
  tags                            = local.common_tags
}

module "workload_subnet_network_security_group_association" {
  source = "../../modules/resources/networking/subnet-network-security-group-association"

  network_security_group_id = module.workload_network_security_group.id
  subnet_id                 = module.workload_virtual_network.subnet_ids.workload
}

module "workload_subnet_route_table_association" {
  source = "../../modules/resources/networking/subnet-route-table-association"

  route_table_id = module.workload_route_table.id
  subnet_id      = module.workload_virtual_network.subnet_ids.workload
}

module "workload_to_hub_virtual_network_peering" {
  source = "../../modules/resources/networking/virtual-network-peering"

  allow_forwarded_traffic      = false
  allow_gateway_transit        = false
  allow_virtual_network_access = true
  name                         = local.names.workload_to_hub_peering
  remote_virtual_network_id    = module.hub_virtual_network.id
  resource_group_name          = module.workload_resource_group.name
  use_remote_gateways          = false
  virtual_network_name         = module.workload_virtual_network.name
}

module "workload_virtual_network" {
  source = "../../modules/resources/networking/virtual-network"

  address_space       = local.networking_config.workload.address_space
  location            = var.location
  name                = local.names.vnet_workload
  resource_group_name = module.workload_resource_group.name
  subnets             = local.networking_config.workload.subnets
  tags                = local.common_tags
}