using Amazon.SQS;
using Microsoft.Extensions.DependencyInjection;
using MyLambdaProject.Common;
using Microsoft.Extensions.Configuration;
using System.IO;

namespace MyLambdaProject
{
    public static class RegisterServices
    {
        public static ServiceProvider ConfigureServices()
        {
            var serviceCollection = new ServiceCollection();

            // Build configuration
            var environment = Environment.GetEnvironmentVariable("ASPNETCORE_ENVIRONMENT") ?? "Production";
            var configuration = new ConfigurationBuilder()
                .SetBasePath(Directory.GetCurrentDirectory())
                .AddJsonFile($"appsettings.{environment}.json", optional: false, reloadOnChange: true)
                .Build();

            serviceCollection.AddSingleton<IConfiguration>(configuration);

            serviceCollection.AddScoped<ILogService<Function>, LogService<Function>>();

            //AWS
            serviceCollection.AddAWSService<IAmazonSQS>();
            serviceCollection.AddScoped<ISqsService, SqsService>(provider =>
            {
                var sqsClient = provider.GetRequiredService<IAmazonSQS>();
                var queueUrl = configuration["AWS:SQS:QueueUrl"];
                return new SqsService(sqsClient, queueUrl!);
            });

            return serviceCollection.BuildServiceProvider();
        }
    }
}