namespace Platform.Sentinel.Options;

public sealed class SentinelOptions
{
    public const string SectionName = "Sentinel";

    public string EnvironmentName { get; set; } = "dev";

    public string WorkloadName { get; set; } = "platform";

    public int ExecutionIntervalSeconds { get; set; } = 300;

    public string KeyVaultUri { get; set; } = string.Empty;

    public string StorageAccountBlobServiceUri { get; set; } = string.Empty;

    public string StorageContainerName { get; set; } = "platform-sentinel";

    public string Message { get; set; } = "landing-zone-operational";

    public string ValidationSecretName { get; set; } = "platform-sentinel-validation-secret";

    public string EventLogSource { get; set; } = "PlatformSentinel";

    public string BlobPrefix { get; set; } = "healthchecks";

    public string SchemaVersion { get; set; } = "1.0.0";

    public string? ManagedIdentityClientId { get; set; }
}