using Amazon.SQS;
using Microsoft.Extensions.DependencyInjection;
using MyLambdaProject.Common;
using Microsoft.Extensions.Configuration;
using System.IO;
using Amazon.SimpleNotificationService;
using Amazon.SecretsManager;

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

            //Services
            serviceCollection.AddScoped<ISecretService, SecretService>();
            serviceCollection.AddScoped<ILogService<Function>, LogService<Function>>();

            return serviceCollection.BuildServiceProvider();
        }
    }
}