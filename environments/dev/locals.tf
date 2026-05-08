locals {
  common_tags = merge(
    var.default_tags,
    {
      environment = var.environment
      managed_by  = "Terraform"
      workload    = var.workload_name
    }
  )

  names = {
    action_group_management_vm                   = "ag-mgmt-${var.environment}"
    backup_policy_virtual_machine                = "bkp-vm-${var.environment}"
    bastion                                      = "bas-hub-${var.environment}"
    blob_private_dns_zone                        = "privatelink.blob.core.windows.net"
    blob_private_dns_zone_link_hub               = "pdns-link-hub-${var.environment}"
    blob_private_dns_zone_link_management        = "pdns-link-management-${var.environment}"
    blob_private_dns_zone_link_workload          = "pdns-link-workload-${var.environment}"
    blob_private_endpoint                        = "pep-blob-hub-${var.environment}"
    firewall                                     = "afw-hub-${var.environment}"
    firewall_diagnostic_settings                 = "diag-firewall-${var.environment}"
    firewall_policy                              = "fwp-hub-${var.environment}"
    hub_network_security_group                   = "nsg-hub-shared-${var.environment}"
    hub_private_endpoints_subnet                 = "snet-hub-private-endpoints-${var.environment}"
    hub_resource_group                           = "rg-${var.resource_prefix}-hub-network-${var.environment}"
    hub_shared_subnet                            = "snet-hub-shared-${var.environment}"
    hub_to_management_peering                    = "peer-hub-to-management-${var.environment}"
    hub_to_workload_peering                      = "peer-hub-to-workload-${var.environment}"
    key_vault                                    = "kv${var.resource_prefix}${var.environment}${random_string.key_vault_suffix.result}"
    key_vault_diagnostic_settings                = "diag-keyvault-${var.environment}"
    key_vault_private_dns_zone                   = "privatelink.vaultcore.azure.net"
    key_vault_private_dns_zone_link_hub          = "pdns-link-kv-hub-${var.environment}"
    key_vault_private_dns_zone_link_management   = "pdns-link-kv-management-${var.environment}"
    key_vault_private_dns_zone_link_workload     = "pdns-link-kv-workload-${var.environment}"
    key_vault_private_endpoint                   = "pep-kv-hub-${var.environment}"
    log_analytics_workspace                      = "law-${var.resource_prefix}-${var.workload_name}-${var.environment}"
    management_data_collection_rule              = "dcr-mgmt-vm-${var.environment}"
    management_data_collection_rule_association  = "dcra-mgmt-vm-${var.environment}"
    management_network_security_group            = "nsg-management-${var.environment}"
    management_resource_group                    = "rg-${var.resource_prefix}-management-network-${var.environment}"
    management_route_table                       = "rt-management-${var.environment}"
    management_subnet                            = "snet-management-${var.environment}"
    management_to_hub_peering                    = "peer-management-to-hub-${var.environment}"
    management_virtual_machine                   = "vm-mgmt-${var.environment}"
    management_virtual_machine_cpu_alert         = "malert-mgmt-cpu-high-${var.environment}"
    management_virtual_machine_extension         = "AzureMonitorAgent"
    management_virtual_machine_heartbeat_alert   = "lalert-mgmt-heartbeat-${var.environment}"
    management_virtual_machine_maintenance       = "mc-mgmt-${var.environment}"
    management_virtual_machine_network_interface = "nic-mgmt-${var.environment}"
    monitoring_resource_group                    = "rg-${var.resource_prefix}-monitoring-${var.environment}"
    public_ip_bastion                            = "pip-bastion-${var.environment}"
    public_ip_firewall                           = "pip-firewall-${var.environment}"
    recovery_services_vault                      = "rsv-${var.resource_prefix}-${var.environment}"
    storage_diagnostic_settings                  = "diag-storage-${var.environment}"
    storage_account                              = "${var.storage_account_name_prefix}${random_string.storage_account_suffix.result}"
    vnet_hub                                     = "vnet-hub-${var.environment}"
    vnet_management                              = "vnet-management-${var.environment}"
    vnet_workload                                = "vnet-workload-${var.environment}"
    workload_network_security_group              = "nsg-workload-${var.environment}"
    workload_resource_group                      = "rg-${var.resource_prefix}-workload-network-${var.environment}"
    workload_route_table                         = "rt-workload-${var.environment}"
    workload_subnet                              = "snet-workload-${var.environment}"
    workload_to_hub_peering                      = "peer-workload-to-hub-${var.environment}"
    bastion_diagnostic_settings                  = "diag-bastion-${var.environment}"
    firewall_subnet                              = "AzureFirewallSubnet"
  }

  networking_config = {
    hub = {
      address_space = ["10.10.0.0/16"]
      subnets = {
        bastion = {
          address_prefixes = ["10.10.0.0/26"]
          name             = "AzureBastionSubnet"
        }
        firewall = {
          address_prefixes = ["10.10.3.0/26"]
          name             = local.names.firewall_subnet
        }
        private_endpoints = {
          address_prefixes = ["10.10.2.0/24"]
          name             = local.names.hub_private_endpoints_subnet
        }
        shared = {
          address_prefixes = ["10.10.1.0/24"]
          name             = local.names.hub_shared_subnet
        }
      }
    }

    management = {
      address_space = ["10.20.0.0/16"]
      subnets = {
        management = {
          address_prefixes = ["10.20.1.0/24"]
          name             = local.names.management_subnet
        }
      }
    }

    workload = {
      address_space = ["10.30.0.0/16"]
      subnets = {
        workload = {
          address_prefixes = ["10.30.1.0/24"]
          name             = local.names.workload_subnet
        }
      }
    }
  }

  diagnostic_logs = {
    bastion = [
      "BastionAuditLogs"
    ]

    firewall = [
      "AzureFirewallApplicationRule",
      "AzureFirewallDnsProxy",
      "AzureFirewallNetworkRule"
    ]

    key_vault = [
      "AuditEvent"
    ]

    storage = [
      "StorageRead",
      "StorageWrite",
      "StorageDelete"
    ]
  }

  diagnostic_metrics = {
    bastion = [
      "AllMetrics"
    ]

    firewall = [
      "AllMetrics"
    ]

    key_vault = [
      "AllMetrics"
    ]

    storage = []
  }

  nsg_rules = {
    hub_shared = {}

    management = {
      allow_inbound_from_hub = {
        access                     = "Allow"
        description                = "ALLOW INBOUND TRAFFIC FROM THE HUB VIRTUAL NETWORK."
        destination_address_prefix = "*"
        destination_port_range     = "*"
        direction                  = "Inbound"
        name                       = "AllowInboundFromHub"
        priority                   = 100
        protocol                   = "*"
        source_address_prefix      = "10.10.0.0/16"
        source_port_range          = "*"
      }
    }

    workload = {
      allow_inbound_from_hub = {
        access                     = "Allow"
        description                = "ALLOW INBOUND TRAFFIC FROM THE HUB VIRTUAL NETWORK."
        destination_address_prefix = "*"
        destination_port_range     = "*"
        direction                  = "Inbound"
        name                       = "AllowInboundFromHub"
        priority                   = 100
        protocol                   = "*"
        source_address_prefix      = "10.10.0.0/16"
        source_port_range          = "*"
      }
    }
  }

  firewall_policy_rule_collection_groups = {
    base_network = {
      application_rule_collections = []
      name                         = "${local.names.firewall_policy}-rcg-base-network"
      nat_rule_collections         = []
      priority                     = 200

      network_rule_collections = [
        {
          action   = "Allow"
          name     = "allow-dns"
          priority = 100
          rules = [
            {
              destination_addresses = ["168.63.129.16"]
              destination_ports     = ["53"]
              name                  = "management-to-azure-dns"
              protocols             = ["TCP", "UDP"]
              source_addresses      = local.networking_config.management.address_space
            },
            {
              destination_addresses = ["168.63.129.16"]
              destination_ports     = ["53"]
              name                  = "workload-to-azure-dns"
              protocols             = ["TCP", "UDP"]
              source_addresses      = local.networking_config.workload.address_space
            }
          ]
        }
      ]
    }

    outbound_application = {
      name                     = "${local.names.firewall_policy}-rcg-outbound-application"
      nat_rule_collections     = []
      network_rule_collections = []
      priority                 = 300

      application_rule_collections = [
        {
          action   = "Allow"
          name     = "allow-management-https"
          priority = 100

          rules = [
            {
              destination_fqdns = sort(distinct(concat(
                var.management_allowed_destination_fqdns,
                var.platform_sentinel_artifact_allowed_fqdns
              )))
              name = "management-to-web"
              protocols = [
                {
                  port = 443
                  type = "Https"
                }
              ]
              source_addresses = local.networking_config.management.address_space
            }
          ]
        }
      ]
    }
  }

  monitoring_config = {
    alerts = {
      cpu_high = {
        frequency   = var.management_virtual_machine_cpu_alert_evaluation_frequency
        severity    = var.management_virtual_machine_cpu_alert_severity
        threshold   = var.management_virtual_machine_cpu_alert_threshold
        window_size = var.management_virtual_machine_cpu_alert_window_size
      }

      heartbeat_missing = {
        evaluation_frequency = var.management_virtual_machine_heartbeat_alert_evaluation_frequency
        severity             = var.management_virtual_machine_heartbeat_alert_severity
        threshold            = var.management_virtual_machine_heartbeat_alert_threshold
        window_duration      = var.management_virtual_machine_heartbeat_alert_window_duration
      }
    }

    management_vm = {
      performance_counter_sampling_frequency_in_seconds = var.management_virtual_machine_performance_counter_sampling_frequency_in_seconds

      performance_counter_specifiers = var.management_virtual_machine_performance_counter_specifiers

      windows_event_log_x_path_queries = var.management_virtual_machine_windows_event_log_x_path_queries
    }
  }
}