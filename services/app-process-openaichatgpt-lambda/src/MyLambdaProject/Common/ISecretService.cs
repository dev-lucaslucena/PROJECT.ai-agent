
namespace MyLambdaProject.Common;

public interface ISecretService
{
    Task<string> GetSecretAsync(string secretName);
}