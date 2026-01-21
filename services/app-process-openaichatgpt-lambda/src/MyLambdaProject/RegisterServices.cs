using Amazon.SQS;
using Microsoft.Extensions.DependencyInjection;
using MyLambdaProject.Common;
using Microsoft.Extensions.Configuration;
using System.IO;
using Amazon.SimpleNotificationService;
using Amazon.SecretsManager;
using Amazon.SimpleSystemsManagement;
using Amazon.SimpleSystemsManagement.Model;

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

            //AWS
            serviceCollection.AddAWSService<IAmazonSecretsManager>();
            serviceCollection.AddAWSService<IAmazonSimpleNotificationService>();
            serviceCollection.AddAWSService<IAmazonSimpleSystemsManagement>();

            //Services
            serviceCollection.AddScoped<ISecretService, SecretService>();
            serviceCollection.AddScoped<ILogService<Function>, LogService<Function>>();
            serviceCollection.AddScoped<ISnsService, SnsService>(provider =>
            {
                var snsClient = provider.GetRequiredService<IAmazonSimpleNotificationService>();
                var queueUrl = configuration["AWS:SNS:TopicArn"];
                return new SnsService(snsClient, queueUrl!);
            });
            
            serviceCollection.AddSingleton<IOpenAiService>(provider =>
            {
                var ssmClient = provider.GetRequiredService<IAmazonSimpleSystemsManagement>();
                var parameterName = configuration["AWS:ParameterStore:ParameterName"];
                var request = new GetParameterRequest
                {
                    Name = parameterName,
                    WithDecryption = true
                };
                var response = ssmClient.GetParameterAsync(request).GetAwaiter().GetResult();
                var apiKey = response.Parameter.Value;

                return new OpenAiService("gpt-4o", apiKey);
            });

            return serviceCollection.BuildServiceProvider();
        }
    }
}