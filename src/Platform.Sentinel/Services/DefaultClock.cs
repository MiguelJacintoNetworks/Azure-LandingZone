using Platform.Sentinel.Abstractions;

namespace Platform.Sentinel.Services;

public sealed class DefaultClock : IClock
{
    public DateTimeOffset GetUtcNow()
    {
        return DateTimeOffset.UtcNow;
    }
}