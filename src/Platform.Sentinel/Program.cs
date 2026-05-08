using Azure.Core;
using Azure.Identity;
using Azure.Security.KeyVault.Secrets;
using Azure.Storage.Blobs;
using Microsoft.Extensions.Options;
using Platform.Sentinel;
using Platform.Sentinel.Abstractions;
using Platform.Sentinel.Options;
using Platform.Sentinel.Services;

HostApplicationBuilder builder = Host.CreateApplicationBuilder(args);

builder.Services.AddWindowsService(options => { options.ServiceName = "Platform Sentinel Service"; });

builder.Services.AddOptions<SentinelOptions>().Bind(builder.Configuration.GetSection(SentinelOptions.SectionName)).Validate(options =>
    {
        if (string.IsNullOrWhiteSpace(options.EnvironmentName))
        {
            return false;
        }

        if (string.IsNullOrWhiteSpace(options.WorkloadName))
        {
            return false;
        }

        if (options.ExecutionIntervalSeconds <= 0)
        {
            return false;
        }

        if (string.IsNullOrWhiteSpace(options.KeyVaultUri) || !Uri.IsWellFormedUriString(options.KeyVaultUri, UriKind.Absolute))
        {
            return false;
        }

        if (string.IsNullOrWhiteSpace(options.StorageAccountBlobServiceUri) || !Uri.IsWellFormedUriString(options.StorageAccountBlobServiceUri, UriKind.Absolute))
        {
            return false;
        }

        if (string.IsNullOrWhiteSpace(options.StorageContainerName))
        {
            return false;
        }

        if (string.IsNullOrWhiteSpace(options.Message))
        {
            return false;
        }

        if (string.IsNullOrWhiteSpace(options.ValidationSecretName))
        {
            return false;
        }

        if (string.IsNullOrWhiteSpace(options.EventLogSource))
        {
            return false;
        }

        if (string.IsNullOrWhiteSpace(options.BlobPrefix))
        {
            return false;
        }

        if (string.IsNullOrWhiteSpace(options.SchemaVersion))
        {
            return false;
        }

        return true;
    }, "THE PLATFORM SENTINEL CONFIGURATION IS INVALID.").ValidateOnStart();

builder.Services.AddSingleton<TokenCredential>(serviceProvider =>
{
    SentinelOptions options = serviceProvider.GetRequiredService<IOptions<SentinelOptions>>().Value;

    return new DefaultAzureCredential(new DefaultAzureCredentialOptions
    {
        ManagedIdentityClientId = options.ManagedIdentityClientId
    });
});

builder.Services.AddSingleton(serviceProvider =>
{
    SentinelOptions options = serviceProvider.GetRequiredService<IOptions<SentinelOptions>>().Value;
    TokenCredential credential = serviceProvider.GetRequiredService<TokenCredential>();

    return new SecretClient(new Uri(options.KeyVaultUri), credential);
});

builder.Services.AddSingleton(serviceProvider =>
{
    SentinelOptions options = serviceProvider.GetRequiredService<IOptions<SentinelOptions>>().Value;
    TokenCredential credential = serviceProvider.GetRequiredService<TokenCredential>();

    return new BlobServiceClient(new Uri(options.StorageAccountBlobServiceUri), credential);
});

builder.Services.AddSingleton<IClock, DefaultClock>();
builder.Services.AddSingleton<IValidationSecretProvider, ValidationSecretProvider>();
builder.Services.AddSingleton<IBlobHealthRecordWriter, BlobHealthRecordWriter>();
builder.Services.AddSingleton<ITelemetryWriter, WindowsEventTelemetryWriter>();
builder.Services.AddSingleton<IPlatformSentinelRunner, PlatformSentinelRunner>();
builder.Services.AddHostedService<Worker>();

IHost host = builder.Build();

await host.RunAsync();