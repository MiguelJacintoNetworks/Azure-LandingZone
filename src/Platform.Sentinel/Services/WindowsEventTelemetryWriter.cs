using System.Diagnostics;
using System.Runtime.Versioning;
using Microsoft.Extensions.Options;
using Platform.Sentinel.Abstractions;
using Platform.Sentinel.Options;

namespace Platform.Sentinel.Services;

[SupportedOSPlatform("windows")]
public sealed class WindowsEventTelemetryWriter : ITelemetryWriter
{
    private readonly SentinelOptions options;
    private readonly ILogger<WindowsEventTelemetryWriter> logger;

    public WindowsEventTelemetryWriter(IOptions<SentinelOptions> options, ILogger<WindowsEventTelemetryWriter> logger)
    {
        this.options = options.Value;
        this.logger = logger;
    }

    public void WriteInformation(string message)
    {
        logger.LogInformation("WRITING INFORMATION EVENT TO WINDOWS EVENT LOG. EVENT LOG SOURCE: {EventLogSource}.", options.EventLogSource);

        EventLog.WriteEntry(options.EventLogSource, message, EventLogEntryType.Information);
    }

    public void WriteError(string message)
    {
        logger.LogError("WRITING ERROR EVENT TO WINDOWS EVENT LOG. EVENT LOG SOURCE: {EventLogSource}.", options.EventLogSource);

        EventLog.WriteEntry(options.EventLogSource, message, EventLogEntryType.Error);
    }
}