# Terraform Azure Modules

## Overview

This repository contains a set of Terraform modules used to deploy and manage Azure resources.

The modules are organized by domain. Each module represents a specific Azure resource or a small group of closely related resources.

All modules follow the same structure:

* `main.tf` defines the resources
* `variables.tf` defines inputs
* `outputs.tf` exposes resource attributes
* `versions.tf` defines required providers

---

## Structure

```text
modules/
└── resources/
    ├── compute/
    ├── governance/
    ├── identity/
    ├── management/
    ├── networking/
    ├── recovery/
    ├── security/
    └── shared/
```

---

# Compute

## Virtual Machine

Creates an Azure Virtual Machine using `azurerm_windows_virtual_machine`.

### Configuration

* Uses a fixed Windows Server image
* Attaches a single network interface
* Enables system-assigned managed identity
* Configures OS disk with standard settings
* Supports patch configuration and reboot settings

### Inputs

* Name, Location, Resource Group
* VM Size
* Admin Username and Password
* Network Interface ID
* Patch Configuration Options
* Tags

### Outputs

* VM ID
* VM Name
* Managed Identity Principal ID
* Managed Identity Tenant ID

---

## Virtual Machine Extension

Creates a VM extension using `azurerm_virtual_machine_extension`.

### Configuration

* Installs an extension on a target VM
* Supports automatic upgrades

### Inputs

* Extension Name
* Target VM ID
* Publisher
* Type
* Version Settings

### Outputs

* Extension ID
* Extension Name

---

# Governance

## Policy Assignment

Creates a subscription-level policy assignment using `azurerm_subscription_policy_assignment`.

### Configuration

* Assigns a policy or initiative to a subscription
* Supports metadata and parameters

### Inputs

* Name
* Subscription ID
* Policy Definition ID
* Display Name and Description
* Metadata and Parameters

### Outputs

* Assignment ID
* Assignment Name

---

## Policy Set Definition

Creates a policy set (initiative) using `azurerm_policy_set_definition`.

### Configuration

* Defines multiple policy references
* Supports optional parameter values

### Inputs

* Name, Display Name, Description
* Policy Type
* Metadata
* Map of Policy Definitions

### Outputs

* Policy Set ID
* Policy Set Name

---

# Identity

## Entra ID Group

Creates a Microsoft Entra ID group using the `msgraph` provider.

### Configuration

* Creates a security group
* Adds members using object IDs

### Inputs

* Display Name
* Description
* Mail Nickname
* List of Member Object IDs

### Outputs

* Group ID
* Display Name

---

## Role Assignment

Creates a role assignment using `azurerm_role_assignment`.

### Configuration

* Assigns a role to a principal at a given scope

### Inputs

* Scope
* Role Definition Name
* Principal ID

### Outputs

* Role Assignment ID

---

# Management

## Log Analytics Workspace

Creates a Log Analytics workspace.

### Configuration

* Defines SKU and retention
* Applies tags

### Inputs

* Name, Location, Resource Group
* SKU
* Retention in Days
* Tags

### Outputs

* Workspace Name
* Workspace ID
* Workspace Resource ID

---

## Diagnostic Settings

Creates diagnostic settings using `azurerm_monitor_diagnostic_setting`.

### Configuration

* Sends logs and metrics to Log Analytics
* Supports multiple categories

### Inputs

* Name
* Target Resource ID
* Workspace ID
* Lists of Logs and Metrics

### Outputs

* Diagnostic Setting ID
* Diagnostic Setting Name

---

## Monitor Data Collection Rule

Creates a data collection rule.

### Configuration

* Sends data to Log Analytics
* Collects performance counters and Windows event logs
* Defines multiple data flows

### Inputs

* Name, Location, Resource Group
* Workspace Resource ID
* Performance Counter Settings
* Event Log Queries
* Tags

### Outputs

* Rule ID
* Rule Name

---

## Monitor Data Collection Rule Association

Associates a data collection rule to a resource.

### Inputs

* Name
* Target Resource ID
* Data Collection Rule ID

### Outputs

* Association ID
* Association Name

---

## Monitor Action Group

Creates an action group.

### Configuration

* Defines email notification

### Inputs

* Name
* Resource Group
* Short Name
* Email Receiver
* Tags

### Outputs

* Action Group ID
* Action Group Name

---

## Monitor Metric Alert

Creates a metric alert.

### Configuration

* Defines metric criteria
* Associates an action group

### Inputs

* Name
* Resource Group
* Scopes
* Metric Configuration
* Threshold and Operator
* Action Group ID
* Tags

### Outputs

* Alert ID
* Alert Name

---

## Monitor Scheduled Query Alert

Creates a log-based alert using Kusto queries.

### Configuration

* Defines query-based alert criteria
* Supports evaluation periods and thresholds

### Inputs

* Name, Location, Resource Group
* Scopes
* Query
* Aggregation Settings
* Threshold
* Action Group ID
* Tags

### Outputs

* Alert ID
* Alert Name

---

## Maintenance Configuration

Creates a maintenance configuration.

### Configuration

* Defines patching schedule
* Supports Windows classifications

### Inputs

* Name, Location, Resource Group
* Schedule Settings
* Reboot Behavior
* Patch Classifications
* Tags

### Outputs

* Configuration ID
* Configuration Name

---

## Maintenance Assignment

Assigns a maintenance configuration to a VM.

### Inputs

* Location
* Maintenance Configuration ID
* VM ID

### Outputs

* Assignment ID

---

# Networking

## Virtual Network

Creates a virtual network and subnets.

### Configuration

* Defines address space
* Creates multiple subnets using a map

### Inputs

* Name, Location, Resource Group
* Address Space
* Subnet Definitions
* Tags

### Outputs

* VNet ID
* VNet Name
* Address Space
* Subnet IDs
* Subnet Names

---

## Virtual Network Peering

Creates a VNet peering.

### Inputs

* Name
* Resource Group
* VNet Name
* Remote VNet ID
* Peering Options

### Outputs

* Peering ID
* Peering Name

---

## Network Interface

Creates a network interface.

### Configuration

* Attaches to a subnet
* Uses dynamic private IP

### Inputs

* Name, Location, Resource Group
* Subnet ID
* Tags

### Outputs

* NIC ID
* Private IP

---

## Public IP

Creates a public IP.

### Inputs

* Name, Location, Resource Group
* Allocation Method
* SKU
* Tags

### Outputs

* Public IP ID
* Public IP Name
* IP Address

---

## Bastion

Creates an Azure Bastion host.

### Configuration

* Uses a subnet and public IP

### Inputs

* Name, Location, Resource Group
* Subnet ID
* Public IP ID
* SKU
* Tags

### Outputs

* Bastion ID
* Bastion Name
* DNS Name

---

## Firewall

Creates an Azure Firewall.

### Configuration

* Uses a subnet and public IP
* Supports firewall policy

### Inputs

* Name, Location, Resource Group
* Subnet ID
* Public IP ID
* Firewall Policy ID
* SKU Settings
* Tags

### Outputs

* Firewall ID
* Firewall Name
* Private IP

---

## Firewall Policy

Creates a firewall policy.

### Inputs

* Name, Location, Resource Group
* SKU
* Threat Intelligence Mode
* Tags

### Outputs

* Policy ID
* Policy Name

---

## Firewall Policy Rule Collection Group

Creates rule collections for a firewall policy.

### Configuration

* Supports network, application, and NAT rules

### Inputs

* Name
* Firewall Policy ID
* Priority
* Rule Collections

### Outputs

* Resource ID
* Name

---

## Network Security Group

Creates an NSG and rules.

### Configuration

* Creates rules using a map

### Inputs

* Name, Location, Resource Group
* Security Rules
* Tags

### Outputs

* NSG ID
* NSG Name

---

## Route Table

Creates a route table.

### Configuration

* Supports multiple routes

### Inputs

* Name, Location, Resource Group
* Routes
* Tags

### Outputs

* Route Table ID
* Route Table Name

---

## Subnet Network Security Group Association

Associates an NSG to a subnet.

### Inputs

* Subnet ID
* NSG ID

### Outputs

* Association ID

---

## Subnet Route Table Association

Associates a route table to a subnet.

### Inputs

* Subnet ID
* Route Table ID

### Outputs

* Association ID

---

## Private Endpoint

Creates a private endpoint.

### Configuration

* Connects to a private resource
* Optionally links DNS zones

### Inputs

* Name, Location, Resource Group
* Subnet ID
* Target Resource ID
* Subresource Names
* DNS Zone IDs
* Tags

### Outputs

* Endpoint ID
* Endpoint Name
* Network Interface Details

---

## Private DNS Zone

Creates a private DNS zone.

### Inputs

* Name
* Resource Group
* Tags

### Outputs

* DNS Zone ID
* DNS Zone Name

---

## Private DNS Zone Virtual Network Link

Links a DNS zone to a VNet.

### Inputs

* Name
* Resource Group
* DNS Zone Name
* VNet ID
* Registration Enabled
* Tags

### Outputs

* Link ID
* Link Name

---

# Recovery

## Recovery Services Vault

Creates a Recovery Services Vault using `azapi_resource`.

### Configuration

* Defines security settings
* Configures soft delete and immutability

### Inputs

* Name, Location
* Resource Group ID
* SKU
* Security Settings
* Tags

### Outputs

* Vault ID
* Vault Name

---

## Backup Policy

Creates a VM backup policy.

### Configuration

* Defines schedule and retention

### Inputs

* Name
* Resource Group
* Vault Name
* Backup Time
* Retention Count

### Outputs

* Policy ID
* Policy Name

---

## Backup Protected Item

Protects a VM using a backup policy.

### Inputs

* Resource Group
* Vault Name
* VM ID
* Policy ID

### Outputs

* Resource ID

---

# Security

## Key Vault

Creates a Key Vault.

### Configuration

* Enforces security settings
* Controls network access and retention

### Inputs

* Name, Location, Resource Group
* Tenant ID
* SKU
* Network Settings
* Retention Settings
* Tags

### Outputs

* Key Vault ID
* Key Vault Name
* Vault URI

---

## Defender for Cloud Security Contact

Defines security contact information.

### Inputs

* Name
* Email
* Phone
* Notification Settings

### Outputs

* Resource ID
* Email

---

## Defender for Cloud Subscription Pricing

Configures Defender for Cloud pricing.

### Inputs

* Tier
* Resource Type
* Subplan

### Outputs

* Resource ID
* Resource Type

---

# Shared

## Resource Group

Creates a resource group.

### Inputs

* Name
* Location
* Tags

### Outputs

* Resource Group ID
* Resource Group Name
* Location

---

## Storage Account

Creates a storage account.

### Configuration

* Enforces TLS settings
* Controls public access
* Defines replication and tier

### Inputs

* Name, Location, Resource Group
* Tier and Replication
* Network Settings
* TLS Settings
* Tags

### Outputs

* Storage Account ID
* Storage Account Name
* Blob Endpoint
* Blob Service Resource ID

```
```