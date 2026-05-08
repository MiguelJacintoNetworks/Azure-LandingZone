using Microsoft.Extensions.Options;
using Platform.Sentinel.Abstractions;
using Platform.Sentinel.Options;

namespace Platform.Sentinel;

public sealed class Worker : BackgroundService
{
    private readonly ILogger<Worker> logger;
    private readonly IPlatformSentinelRunner platformSentinelRunner;
    private readonly SentinelOptions options;

    public Worker(ILogger<Worker> logger, IPlatformSentinelRunner platformSentinelRunner, IOptions<SentinelOptions> options)
    {
        this.logger = logger;
        this.platformSentinelRunner = platformSentinelRunner;
        this.options = options.Value;
    }

    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        logger.LogInformation("PLATFORM SENTINEL WORKER STARTED. EXECUTION INTERVAL SECONDS: {ExecutionIntervalSeconds}.", options.ExecutionIntervalSeconds);

        while (!stoppingToken.IsCancellationRequested)
        {
            try
            {
                await platformSentinelRunner.RunOnceAsync(stoppingToken);
            }
            catch (OperationCanceledException) when (stoppingToken.IsCancellationRequested)
            {
                logger.LogInformation("PLATFORM SENTINEL WORKER CANCELLATION REQUEST RECEIVED.");
                break;
            }
            catch (Exception ex)
            {
                logger.LogError(ex, "PLATFORM SENTINEL WORKER ITERATION FAILED.");
            }

            try
            {
                await Task.Delay(TimeSpan.FromSeconds(options.ExecutionIntervalSeconds), stoppingToken);
            }
            catch (OperationCanceledException) when (stoppingToken.IsCancellationRequested)
            {
                logger.LogInformation("PLATFORM SENTINEL WORKER DELAY INTERRUPTED BY CANCELLATION.");
                break;
            }
        }

        logger.LogInformation("PLATFORM SENTINEL WORKER STOPPED.");
    }
}