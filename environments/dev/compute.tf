module "management_virtual_machine" {
  source = "../../modules/resources/compute/windows-virtual-machine"

  admin_password                                         = var.vm_admin_password
  admin_username                                         = var.vm_admin_username
  bypass_platform_safety_checks_on_user_schedule_enabled = var.management_virtual_machine_bypass_platform_safety_checks_on_user_schedule_enabled
  location                                               = var.location
  name                                                   = local.names.management_virtual_machine
  network_interface_id                                   = module.management_virtual_machine_network_interface.id
  patch_mode                                             = var.management_virtual_machine_patch_mode
  reboot_setting                                         = var.management_virtual_machine_reboot_setting
  resource_group_name                                    = module.management_resource_group.name
  size                                                   = var.management_virtual_machine_size
  tags                                                   = local.common_tags
}

module "management_virtual_machine_extension" {
  source = "../../modules/resources/compute/virtual-machine-extension-azure-monitor-agent-windows"

  name               = local.names.management_virtual_machine_extension
  virtual_machine_id = module.management_virtual_machine.id
}

module "management_virtual_machine_network_interface" {
  source = "../../modules/resources/networking/network-interface"

  location            = var.location
  name                = local.names.management_virtual_machine_network_interface
  resource_group_name = module.management_resource_group.name
  subnet_id           = module.management_virtual_network.subnet_ids.management
  tags                = local.common_tags
}