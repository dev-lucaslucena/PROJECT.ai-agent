using AWS.Lambda.Powertools.Logging;

namespace MyLambdaProject.Common
{
    public class LogService<T> : ILogService<T>
    {
        public void LogInfo(string message)
        {
            Logger.LogInformation($"[{typeof(T).Name}] {message}");
        }

        public void LogError(Exception ex, string message)
        {
            Logger.LogError(ex, $"[{typeof(T).Name}] {message}");
        }

        public void LogWarning(string message)
        {
            Logger.LogWarning($"[{typeof(T).Name}] {message}");
        }
    }
}