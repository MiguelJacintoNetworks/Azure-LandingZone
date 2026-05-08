using Platform.Sentinel.Models;

namespace Platform.Sentinel.Abstractions;

public interface IBlobHealthRecordWriter
{
    Task<BlobUploadResult> WriteAsync(string containerName, SentinelExecutionRecord executionRecord, CancellationToken cancellationToken);
}