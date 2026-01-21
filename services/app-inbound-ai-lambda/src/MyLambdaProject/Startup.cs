using Amazon.SQS;
using MyLambdaProject.Services;
using Amazon.Extensions.NETCore.Setup;
using Amazon.DynamoDBv2;
using MyLambdaProject.Middlewares;
using MyLambdaProject.Controllers;

namespace MyLambdaProject;

public class Startup
{
    public Startup(IConfiguration configuration)
    {
        Configuration = configuration;
    }

    public IConfiguration Configuration { get; }

    // This method gets called by the runtime. Use this method to add services to the container
    public void ConfigureServices(IServiceCollection services)
    {    
        services.AddScoped<ILogService<WhatsappController>, LogService<WhatsappController>>();
        services.AddScoped<ILogService<ErrorHandlingMiddleware>, LogService<ErrorHandlingMiddleware>>();
        services.AddScoped<ILogService<RequestLoggingMiddleware>, LogService<RequestLoggingMiddleware>>();

        services.AddAWSService<IAmazonSQS>();
        services.AddAWSService<IAmazonDynamoDB>();     

        services.AddScoped<ISqsService, SqsService>(provider =>
        {
            var sqsClient = provider.GetRequiredService<IAmazonSQS>();
            var queueUrl = Configuration["AWS:SQS:QueueUrl"];
            return new SqsService(sqsClient, queueUrl);
        });
        services.AddScoped<IDynamoDbService, DynamoDbService>();

        services.AddControllers(options =>
        {
            // Disable data annotations validation
            options.ModelValidatorProviders.Clear();
        });
    }

    // This method gets called by the runtime. Use this method to configure the HTTP request pipeline
    public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
    {
        if (env.IsDevelopment())
        {
            app.UseDeveloperExceptionPage();
        }

        app.UseHttpsRedirection();

        app.UseRouting();
        app.UseMiddleware<RequestLoggingMiddleware>();
        app.UseMiddleware<ErrorHandlingMiddleware>();
        app.UseEndpoints(endpoints =>
        {
            endpoints.MapControllers();
            endpoints.MapGet("/", async context =>
            {
                await context.Response.WriteAsync("Welcome to running ASP.NET Core on AWS Lambda");
            });
        });
    }
}