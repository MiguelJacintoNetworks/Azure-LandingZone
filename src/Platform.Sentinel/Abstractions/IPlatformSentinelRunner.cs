namespace Platform.Sentinel.Abstractions;

public interface IPlatformSentinelRunner
{
    Task RunOnceAsync(CancellationToken cancellationToken);
}