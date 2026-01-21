using Amazon.Lambda.Core;
using Amazon.Lambda.SQSEvents;
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
                var sqs = scope.ServiceProvider.GetRequiredService<ISqsService>();
                var log = scope.ServiceProvider.GetRequiredService<ILogService<Function>>();

                log.LogInfo($"Processed message {message.MessageId}");
                log.LogInfo($"Message body: {message.Body}");

                // TODO: in the future, put a logic to redirect processing to best AI queue
                await sqs.SendMessageAsync(message.Body);

                await Task.CompletedTask;
            }
        }
    }
}