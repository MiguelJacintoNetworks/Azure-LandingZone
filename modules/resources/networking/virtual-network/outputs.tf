output "name" {
  description = "NAME OF THE VIRTUAL NETWORK."
  value       = azurerm_virtual_network.this.name
}

output "id" {
  description = "RESOURCE ID OF THE VIRTUAL NETWORK."
  value       = azurerm_virtual_network.this.id
}

output "address_space" {
  description = "ADDRESS SPACE OF THE VIRTUAL NETWORK."
  value       = azurerm_virtual_network.this.address_space
}

output "subnet_ids" {
  description = "RESOURCE IDS OF THE DEPLOYED SUBNETS."

  value = {
    for key, subnet in azurerm_subnet.this : key => subnet.id
  }
}

output "subnet_names" {
  description = "NAMES OF THE DEPLOYED SUBNETS."

  value = {
    for key, subnet in azurerm_subnet.this : key => subnet.name
  }
}