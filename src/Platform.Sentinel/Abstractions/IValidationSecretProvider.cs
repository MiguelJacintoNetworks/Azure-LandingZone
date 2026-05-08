namespace Platform.Sentinel.Abstractions;

public interface IValidationSecretProvider
{
    Task<string> GetValidationSecretAsync(CancellationToken cancellationToken);
}