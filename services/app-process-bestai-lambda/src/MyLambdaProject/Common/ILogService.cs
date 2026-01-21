namespace MyLambdaProject.Common
{
    public interface ILogService<T>
    {
        void LogInfo(string message);
        void LogError(string message);
        void LogWarning(string message);
    }
}