using Xunit;
using Amazon.Lambda.TestUtilities;
using Amazon.Lambda.SQSEvents;
using System.Threading.Tasks;
using System.Collections.Generic;
using Moq;
using Microsoft.Extensions.DependencyInjection;
using MyLambdaProject.Common;

namespace MyLambdaProject.Tests
{
    public class FunctionTest
    {
        [Fact]
        public async Task TestSQSLambdaFunction()
        {
            // Arrange
            var sqsEvent = new SQSEvent
            {
                Records = new List<SQSEvent.SQSMessage>
                {
                    new SQSEvent.SQSMessage
                    {
                        MessageId = "19dd0b57-b21e-4ac1-bd88-01bbb068cb78",
                        ReceiptHandle = "MessageReceiptHandle",
                        Body = "Hello from SQS!",
                        Attributes = new Dictionary<string, string>
                        {
                            { "ApproximateReceiveCount", "1" },
                            { "SentTimestamp", "1523232000000" },
                            { "SenderId", "123456789012" },
                            { "ApproximateFirstReceiveTimestamp", "1523232000001" }
                        },
                        MessageAttributes = new Dictionary<string, SQSEvent.MessageAttribute>(),
                        Md5OfBody = "7b270e59b47ff90a553787216d55d91d",
                        EventSource = "aws:sqs",
                        EventSourceArn = "arn:aws:sqs:us-east-1:123456789012:MyQueue",
                        AwsRegion = "us-east-1"
                    }
                }
            };

            var context = new TestLambdaContext();

            // Mock the ISqsService
            var mockSqsService = new Mock<ISqsService>();
            mockSqsService.Setup(sqs => sqs.SendMessageAsync(It.IsAny<string>()))
                          .Returns(Task.CompletedTask);

            // Mock the ILogService
            var mockLogService = new Mock<ILogService<Function>>();
            mockLogService.Setup(log => log.LogInfo(It.IsAny<string>()));

            // Create a service collection and replace the actual services with mocks
            var serviceCollection = new ServiceCollection();
            serviceCollection.AddSingleton(mockSqsService.Object);
            serviceCollection.AddSingleton(mockLogService.Object);

            // Build the service provider
            var serviceProvider = serviceCollection.BuildServiceProvider();

            // Replace the service provider in the Function class
            var function = new Function();
            var field = typeof(Function).GetField("_serviceProvider", System.Reflection.BindingFlags.NonPublic | System.Reflection.BindingFlags.Instance);
            field.SetValue(function, serviceProvider);

            // Act
            await function.FunctionHandler(sqsEvent, context);

            // Assert
            mockSqsService.Verify(sqs => sqs.SendMessageAsync(It.IsAny<string>()), Times.Once);
            mockLogService.Verify(log => log.LogInfo(It.IsAny<string>()), Times.AtLeastOnce);
        }
    }
}