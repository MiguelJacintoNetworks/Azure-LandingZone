using System.Text.Json;
using Azure.Storage.Blobs;
using Microsoft.Extensions.Options;
using Platform.Sentinel.Abstractions;
using Platform.Sentinel.Models;
using Platform.Sentinel.Options;

namespace Platform.Sentinel.Services;

public sealed class BlobHealthRecordWriter : IBlobHealthRecordWriter
{
    private readonly BlobServiceClient blobServiceClient;
    private readonly SentinelOptions options;
    private readonly ILogger<BlobHealthRecordWriter> logger;

    public BlobHealthRecordWriter(BlobServiceClient blobServiceClient, IOptions<SentinelOptions> options, ILogger<BlobHealthRecordWriter> logger)
    {
        this.blobServiceClient = blobServiceClient;
        this.options = options.Value;
        this.logger = logger;
    }

    public async Task<BlobUploadResult> WriteAsync(string containerName, SentinelExecutionRecord executionRecord, CancellationToken cancellationToken)
    {
        if (string.IsNullOrWhiteSpace(containerName))
        {
            throw new InvalidOperationException("THE STORAGE CONTAINER NAME MUST NOT BE EMPTY.");
        }

        BlobContainerClient containerClient = blobServiceClient.GetBlobContainerClient(containerName);

        string blobName = $"{options.BlobPrefix}/{options.EnvironmentName}/" + $"{executionRecord.TimestampUtc:yyyy/MM/dd}/" + $"platform-sentinel-{executionRecord.TimestampUtc:HHmmssfff}.json";

        BlobClient blobClient = containerClient.GetBlobClient(blobName);

        byte[] content = JsonSerializer.SerializeToUtf8Bytes(executionRecord, new JsonSerializerOptions { WriteIndented = true });

        await using MemoryStream memoryStream = new(content, writable: false);

        logger.LogInformation("UPLOADING PLATFORM SENTINEL EXECUTION RECORD TO BLOB STORAGE. CONTAINER NAME: {ContainerName}. BLOB NAME: {BlobName}.", containerName, blobName);

        await blobClient.UploadAsync(memoryStream, overwrite: false, cancellationToken: cancellationToken);

        return new BlobUploadResult
        {
            ContainerName = containerName,
            BlobName = blobName,
            BlobUri = blobClient.Uri
        };
    }
}