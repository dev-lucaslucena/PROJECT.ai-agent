namespace MyLambdaProject.Common;

public interface IOpenAiService
    {
        Task<string> GetCompletionAsync(string prompt);
    }