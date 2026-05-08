resource "azurerm_maintenance_configuration" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  scope = "InGuestPatch"

  in_guest_user_patch_mode = "User"

  window {
    start_date_time = var.start_date_time
    duration        = var.duration
    time_zone       = var.time_zone
    recur_every     = var.recur_every
  }

  install_patches {
    reboot = var.reboot_setting

    windows {
      classifications_to_include = var.windows_classifications
    }
  }

  tags = var.tags
}