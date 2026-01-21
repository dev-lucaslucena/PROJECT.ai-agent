using Amazon.SQS;
using Amazon.SQS.Model;
using System.Threading.Tasks;

namespace MyLambdaProject.Common
{
    public class SqsService : ISqsService
    {
        private readonly IAmazonSQS _sqsClient;
        private readonly string _queueUrl;

        public SqsService(IAmazonSQS sqsClient, string queueUrl)
        {
            _sqsClient = sqsClient;
            _queueUrl = queueUrl;
        }

        public async Task SendMessageAsync(string message)
        {
            var sendMessageRequest = new SendMessageRequest
            {
                QueueUrl = _queueUrl,
                MessageBody = message,
                MessageGroupId = "1"
            };
            await _sqsClient.SendMessageAsync(sendMessageRequest);
        }
    }
}