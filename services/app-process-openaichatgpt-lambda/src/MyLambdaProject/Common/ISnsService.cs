namespace MyLambdaProject.Common;

public interface ISnsService
{
    Task PublishMessageAsync(string message);
}