namespace Platform.Sentinel.Models;

public sealed class SentinelExecutionRecord
{
    public string SchemaVersion { get; init; } = string.Empty;

    public DateTimeOffset TimestampUtc { get; init; }

    public string MachineName { get; init; } = string.Empty;

    public string EnvironmentName { get; init; } = string.Empty;

    public string WorkloadName { get; init; } = string.Empty;

    public bool KeyVaultReadSucceeded { get; init; }

    public bool BlobUploadSucceeded { get; init; }

    public string StorageContainerName { get; init; } = string.Empty;

    public string Message { get; init; } = string.Empty;

    public string Status { get; init; } = string.Empty;

    public string? BlobName { get; init; }

    public string? BlobUri { get; init; }

    public string? ErrorMessage { get; init; }
}