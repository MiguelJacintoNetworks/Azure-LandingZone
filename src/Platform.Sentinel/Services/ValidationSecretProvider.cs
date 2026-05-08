using Azure.Security.KeyVault.Secrets;
using Microsoft.Extensions.Options;
using Platform.Sentinel.Abstractions;
using Platform.Sentinel.Options;

namespace Platform.Sentinel.Services;

public sealed class ValidationSecretProvider : IValidationSecretProvider
{
    private readonly SecretClient secretClient;
    private readonly SentinelOptions options;
    private readonly ILogger<ValidationSecretProvider> logger;

    public ValidationSecretProvider(SecretClient secretClient, IOptions<SentinelOptions> options, ILogger<ValidationSecretProvider> logger)
    {
        this.secretClient = secretClient;
        this.options = options.Value;
        this.logger = logger;
    }

    public async Task<string> GetValidationSecretAsync(CancellationToken cancellationToken)
    {
        logger.LogInformation("READING PLATFORM SENTINEL VALIDATION SECRET FROM KEY VAULT. SECRET NAME: {ValidationSecretName}.", options.ValidationSecretName);

        KeyVaultSecret validationSecret = await secretClient.GetSecretAsync(options.ValidationSecretName, cancellationToken: cancellationToken);

        return validationSecret.Value;
    }
}