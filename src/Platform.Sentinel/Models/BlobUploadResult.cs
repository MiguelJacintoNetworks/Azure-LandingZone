namespace Platform.Sentinel.Models;

public sealed class BlobUploadResult
{
    public string ContainerName { get; init; } = string.Empty;

    public string BlobName { get; init; } = string.Empty;

    public Uri BlobUri { get; init; } = new("https://localhost");
}