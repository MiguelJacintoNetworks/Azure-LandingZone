using Microsoft.Extensions.Options;
using Platform.Sentinel.Abstractions;
using Platform.Sentinel.Models;
using Platform.Sentinel.Options;

namespace Platform.Sentinel.Services;

public sealed class PlatformSentinelRunner : IPlatformSentinelRunner
{
    private readonly IClock clock;
    private readonly IValidationSecretProvider validationSecretProvider;
    private readonly IBlobHealthRecordWriter blobHealthRecordWriter;
    private readonly ITelemetryWriter telemetryWriter;
    private readonly SentinelOptions options;
    private readonly ILogger<PlatformSentinelRunner> logger;

    public PlatformSentinelRunner(IClock clock, IValidationSecretProvider validationSecretProvider, IBlobHealthRecordWriter blobHealthRecordWriter, ITelemetryWriter telemetryWriter, IOptions<SentinelOptions> options, ILogger<PlatformSentinelRunner> logger)
    {
        this.clock = clock;
        this.validationSecretProvider = validationSecretProvider;
        this.blobHealthRecordWriter = blobHealthRecordWriter;
        this.telemetryWriter = telemetryWriter;
        this.options = options.Value;
        this.logger = logger;
    }

    public async Task RunOnceAsync(CancellationToken cancellationToken)
    {
        DateTimeOffset timestampUtc = clock.GetUtcNow();

        bool keyVaultReadSucceeded = false;
        bool blobUploadSucceeded = false;
        string? blobName = null;
        string? blobUri = null;
        string validationSecretHashPreview;

        try
        {
            logger.LogInformation("STARTING PLATFORM SENTINEL EXECUTION. ENVIRONMENT NAME: {EnvironmentName}. WORKLOAD NAME: {WorkloadName}. MACHINE NAME: {MachineName}.", options.EnvironmentName, options.WorkloadName, Environment.MachineName);

            string validationSecret = await validationSecretProvider.GetValidationSecretAsync(cancellationToken);
            keyVaultReadSucceeded = true;

            validationSecretHashPreview = validationSecret.Length >= 4 ? validationSecret.Substring(0, 4) : validationSecret;

            SentinelExecutionRecord preliminaryRecord = new()
            {
                SchemaVersion = options.SchemaVersion,
                TimestampUtc = timestampUtc,
                MachineName = Environment.MachineName,
                EnvironmentName = options.EnvironmentName,
                WorkloadName = options.WorkloadName,
                KeyVaultReadSucceeded = true,
                BlobUploadSucceeded = false,
                StorageContainerName = options.StorageContainerName,
                Message = options.Message,
                Status = "RUNNING"
            };

            BlobUploadResult uploadResult = await blobHealthRecordWriter.WriteAsync(options.StorageContainerName, preliminaryRecord, cancellationToken);

            blobUploadSucceeded = true;
            blobName = uploadResult.BlobName;
            blobUri = uploadResult.BlobUri.ToString();

            telemetryWriter.WriteInformation($"PLATFORM SENTINEL EXECUTION SUCCEEDED. MACHINE NAME: {Environment.MachineName}. ENVIRONMENT NAME: {options.EnvironmentName}. WORKLOAD NAME: {options.WorkloadName}. STORAGE CONTAINER NAME: {options.StorageContainerName}. BLOB NAME: {blobName}. BLOB URI: {blobUri}. VALIDATION SECRET PREFIX: {validationSecretHashPreview}.");

            logger.LogInformation("PLATFORM SENTINEL EXECUTION COMPLETED SUCCESSFULLY. BLOB NAME: {BlobName}.", blobName);
        }
        catch (Exception ex)
        {
            telemetryWriter.WriteError($"PLATFORM SENTINEL EXECUTION FAILED. MACHINE NAME: {Environment.MachineName}. ENVIRONMENT NAME: {options.EnvironmentName}. WORKLOAD NAME: {options.WorkloadName}. KEY VAULT READ SUCCEEDED: {keyVaultReadSucceeded}. BLOB UPLOAD SUCCEEDED: {blobUploadSucceeded}. STORAGE CONTAINER NAME: {options.StorageContainerName}. BLOB NAME: {blobName}. BLOB URI: {blobUri}. ERROR MESSAGE: {ex.Message}");

            logger.LogError(ex, "PLATFORM SENTINEL EXECUTION FAILED. KEY VAULT READ SUCCEEDED: {KeyVaultReadSucceeded}. BLOB UPLOAD SUCCEEDED: {BlobUploadSucceeded}.", keyVaultReadSucceeded, blobUploadSucceeded);

            throw;
        }
    }
}