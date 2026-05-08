namespace Platform.Sentinel.Abstractions;

public interface IClock
{
    DateTimeOffset GetUtcNow();
}