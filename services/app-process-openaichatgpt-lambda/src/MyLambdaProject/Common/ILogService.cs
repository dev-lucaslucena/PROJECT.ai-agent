namespace MyLambdaProject.Common
{
    public interface ILogService<T>
    {
        void LogInfo(string message);
        void LogError(Exception ex, string message);
        void LogWarning(string message);
    }
}