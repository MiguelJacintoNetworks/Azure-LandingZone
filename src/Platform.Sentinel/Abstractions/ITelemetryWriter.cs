namespace Platform.Sentinel.Abstractions;

public interface ITelemetryWriter
{
    void WriteInformation(string message);

    void WriteError(string message);
}