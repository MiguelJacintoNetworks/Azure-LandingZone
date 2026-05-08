locals {
  platform_sentinel = {
    storage_container_name     = "platform-sentinel"
    validation_secret_name     = "platform-sentinel-validation-secret"
    event_log_source           = "PlatformSentinel"
    install_extension_name     = "InstallPlatformSentinel"
    install_script_file_name   = "install-platform-sentinel.ps1"
    package_file_name          = "Platform.Sentinel.zip"
    service_blob_prefix        = "healthchecks"
    service_schema_version     = "1.0.0"
    execution_interval_seconds = 300
    message_value              = "landing-zone-operational"
  }
}

module "platform_sentinel_storage_container" {
  source = "../../modules/resources/shared/storage-container"

  name                  = local.platform_sentinel.storage_container_name
  storage_account_id    = module.workload_storage_account.id
  container_access_type = "private"
}

module "management_virtual_machine_storage_blob_data_contributor_role_assignment" {
  source = "../../modules/resources/identity/role-assignment"

  principal_id         = module.management_virtual_machine.principal_id
  role_definition_name = "Storage Blob Data Contributor"
  scope                = module.workload_storage_account.id
}

module "management_virtual_machine_artifact_storage_blob_reader_role_assignment" {
  source = "../../modules/resources/identity/role-assignment"

  principal_id         = module.management_virtual_machine.principal_id
  role_definition_name = "Storage Blob Data Reader"
  scope                = var.platform_sentinel_artifact_storage_account_id
}

module "management_virtual_machine_platform_sentinel_extension" {
  count  = var.enable_platform_sentinel_extension ? 1 : 0
  source = "../../modules/resources/compute/virtual-machine-extension-custom-script"

  name               = local.platform_sentinel.install_extension_name
  virtual_machine_id = module.management_virtual_machine.id

  settings = jsonencode({})

  protected_settings = jsonencode({
    fileUris = [
      "https://${var.platform_sentinel_artifact_storage_account_name}.blob.core.windows.net/${var.platform_sentinel_artifact_container_name}/${var.platform_sentinel_package_blob_name}",
      "https://${var.platform_sentinel_artifact_storage_account_name}.blob.core.windows.net/${var.platform_sentinel_artifact_container_name}/${var.platform_sentinel_install_script_blob_name}"
    ]
    commandToExecute = join(" ", [
      "powershell.exe",
      "-ExecutionPolicy", "Bypass",
      "-File", format(
        "\"./platform-sentinel/%s/%s/%s\"",
        var.environment,
        var.platform_sentinel_version,
        local.platform_sentinel.install_script_file_name
      ),
      "-PackageZip", format(
        "\"./platform-sentinel/%s/%s/%s\"",
        var.environment,
        var.platform_sentinel_version,
        local.platform_sentinel.package_file_name
      ),
      "-KeyVaultUri", format("\"%s\"", module.key_vault.vault_uri),
      "-StorageAccountBlobServiceUri", format("\"%s\"", module.workload_storage_account.primary_blob_endpoint),
      "-EnvironmentName", format("\"%s\"", var.environment),
      "-WorkloadName", format("\"%s\"", var.workload_name),
      "-StorageContainerName", format("\"%s\"", local.platform_sentinel.storage_container_name),
      "-Message", format("\"%s\"", local.platform_sentinel.message_value),
      "-ValidationSecretName", format("\"%s\"", local.platform_sentinel.validation_secret_name),
      "-EventLogSource", format("\"%s\"", local.platform_sentinel.event_log_source),
      "-BlobPrefix", format("\"%s\"", local.platform_sentinel.service_blob_prefix),
      "-SchemaVersion", format("\"%s\"", local.platform_sentinel.service_schema_version),
      "-ExecutionIntervalSeconds", tostring(local.platform_sentinel.execution_interval_seconds)
    ])
    managedIdentity = {}
  })

  depends_on = [
    module.management_virtual_machine_extension,
    module.management_virtual_machine_key_vault_secrets_officer_role_assignment,
    module.management_virtual_machine_storage_blob_data_contributor_role_assignment,
    module.management_virtual_machine_artifact_storage_blob_reader_role_assignment,
    module.platform_sentinel_storage_container
  ]
}