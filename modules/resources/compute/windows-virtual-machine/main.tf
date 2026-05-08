resource "azurerm_windows_virtual_machine" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  size                = var.size

  admin_username = var.admin_username
  admin_password = var.admin_password

  network_interface_ids = [
    var.network_interface_id
  ]

  patch_mode                                             = var.patch_mode
  bypass_platform_safety_checks_on_user_schedule_enabled = var.bypass_platform_safety_checks_on_user_schedule_enabled
  reboot_setting                                         = var.reboot_setting

  provision_vm_agent = true

  os_disk {
    caching              = var.os_disk_caching
    storage_account_type = var.os_disk_storage_account_type
  }

  source_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = var.image_version
  }

  identity {
    type = var.identity_type
  }

  tags = var.tags

  lifecycle {
    ignore_changes = [
      admin_password
    ]
  }
}