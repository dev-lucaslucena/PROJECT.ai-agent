using Amazon.SimpleNotificationService;
using Amazon.SimpleNotificationService.Model;
using AWS.Lambda.Powertools.Logging;
using System.Threading.Tasks;

namespace MyLambdaProject.Common
{

    public class SnsService : ISnsService
    {
        private readonly IAmazonSimpleNotificationService _snsClient;
        private readonly string _topicArn;

        public SnsService(IAmazonSimpleNotificationService snsClient, string topicArn)
        {
            _snsClient = snsClient;
            _topicArn = topicArn;
        }

        public async Task PublishMessageAsync(string message)
        {
            var request = new PublishRequest
            {
                Message = message,
                TopicArn = _topicArn,
                MessageAttributes = new Dictionary<string, MessageAttributeValue>
                {                      
                    { 
                        "app", 
                        new MessageAttributeValue { DataType = "String", StringValue = "whatsapp" }
                    }
                }
            };

            await _snsClient.PublishAsync(request);
        }
    }
}