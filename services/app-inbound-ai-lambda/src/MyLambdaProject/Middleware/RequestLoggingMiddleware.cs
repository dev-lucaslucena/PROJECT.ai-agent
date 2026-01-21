
namespace MyLambdaProject.Middlewares;

public class RequestLoggingMiddleware
{
    private readonly RequestDelegate _next;
    private readonly ILogger<RequestLoggingMiddleware> _logger;

    public RequestLoggingMiddleware(RequestDelegate next, ILogger<RequestLoggingMiddleware> logger)
    {
        _next = next;
        _logger = logger;
    }

    public async Task InvokeAsync(HttpContext context)
    {
        // Log the request method and path
        _logger.LogInformation("Request Method: {Method}", context.Request.Method);
        _logger.LogInformation("Request Path: {Path}", context.Request.Path);

        // Log the request headers
        var headers = string.Join(", ", context.Request.Headers.Select(header => $"{header.Key}: {header.Value}"));
        _logger.LogInformation(headers);

        // Log the request body
        context.Request.EnableBuffering();
        var bodyAsText = await new StreamReader(context.Request.Body).ReadToEndAsync();
        context.Request.Body.Position = 0;
        _logger.LogInformation("Request Body: {Body}", bodyAsText);

        // Call the next middleware in the pipeline
        await _next(context);
    }
}