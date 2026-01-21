using Amazon.Lambda.Core;
using Amazon.Lambda.SQSEvents;
using Amazon.SimpleNotificationService;
using AWS.Lambda.Powertools.Logging;
using Microsoft.Extensions.DependencyInjection;
using MyLambdaProject.Common;

[assembly: LambdaSerializer(typeof(Amazon.Lambda.Serialization.SystemTextJson.DefaultLambdaJsonSerializer))]

namespace MyLambdaProject
{
    public class Function
    {
        private readonly ServiceProvider _serviceProvider;

        public Function()
        {
            _serviceProvider = RegisterServices.ConfigureServices();
        }

        [Logging(LogEvent = true)]
        public async Task FunctionHandler(SQSEvent evnt, ILambdaContext context)
        {
            foreach (var message in evnt.Records)
            {
                await ProcessMessageAsync(message, context);
            }
        }

        private async Task ProcessMessageAsync(SQSEvent.SQSMessage message, ILambdaContext context)
        {
            using (var scope = _serviceProvider.CreateScope())
            {
                // Retrieve your service here
                var log = scope.ServiceProvider.GetRequiredService<ILogService<Function>>();
                var openAI = scope.ServiceProvider.GetRequiredService<IOpenAiService>();
                var sns = scope.ServiceProvider.GetRequiredService<ISnsService>();

                try
                {
                    log.LogInfo($"Processed message {message.MessageId}");
                    log.LogInfo($"Message body: {message.Body}");

                    string chatCompletion = await openAI.GetCompletionAsync(message.Body);
                    await sns.PublishMessageAsync(chatCompletion);

                    await Task.CompletedTask;
                }
                catch (Exception ex)
                {
                    log.LogError(ex, $"Error processing message {message.MessageId}");
                    throw;
                }
            }
        }
    }
}