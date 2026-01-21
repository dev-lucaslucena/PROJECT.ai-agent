using System.Text;
using System.Text.Json;
using System.Text.Json.Serialization;
using Amazon.Lambda.Core;
using Amazon.Lambda.SNSEvents;
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
        private static readonly HttpClient client = new HttpClient();

        public Function()
        {
            _serviceProvider = RegisterServices.ConfigureServices();
        }

        [Logging(LogEvent = true)]
        public async Task FunctionHandler(SNSEvent evnt, ILambdaContext context)
        {
            foreach (var record in evnt.Records)
            {
                await ProcessMessageAsync(record.Sns, context);
            }
        }

        private async Task ProcessMessageAsync(SNSEvent.SNSMessage message, ILambdaContext context)
        {
            using (var scope = _serviceProvider.CreateScope())
            {
                // Retrieve your service here
                var log = scope.ServiceProvider.GetRequiredService<ILogService<Function>>();

                log.LogInfo($"Processed message {message.MessageId}");
                log.LogInfo($"Message body: {message.Message}");

                //TODO: read the docs to know how to get permanent access token 
                await SendMessageAsync("ACCESS_TOKEN_HERE", "344910242049913", "5511912520429", "this is a test message");

                await Task.CompletedTask;
            }
        }

        private async Task SendMessageAsync(string accessToken, string phoneNumberId, string recipientPhoneNumber, string messageText)
        {
            var url = $"https://graph.facebook.com/v21.0/{phoneNumberId}/messages";
            client.DefaultRequestHeaders.Authorization = new System.Net.Http.Headers.AuthenticationHeaderValue("Bearer", accessToken);

            var messageData = new
            {
                messaging_product = "whatsapp",
                to = recipientPhoneNumber,
                type = "template",
                template = new {
                    name = "hello_world",
                    language = new {
                        code = "en_US"
                    }
                }
            };

            var content = new StringContent(JsonSerializer.Serialize(messageData), Encoding.UTF8, "application/json");

            var response = await client.PostAsync(url, content);
            response.EnsureSuccessStatusCode();

            var responseBody = await response.Content.ReadAsStringAsync();
            Console.WriteLine(responseBody);
        }
    }
}