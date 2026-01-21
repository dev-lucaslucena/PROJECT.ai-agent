using System.Text.Json;
using Xunit;
using Amazon.Lambda.Core;
using Amazon.Lambda.TestUtilities;
using Amazon.Lambda.APIGatewayEvents;



namespace MyLambdaProject.Tests;

public class WhatsappControllerTests
{
    [Fact]
    public async Task TestPostError()
    {
        var lambdaFunction = new LambdaEntryPoint();

        var requestStr = File.ReadAllText("./SampleRequests/InboudAiWhatsapp-Post.json");
        var request = JsonSerializer.Deserialize<APIGatewayHttpApiV2ProxyRequest>(requestStr, new JsonSerializerOptions
        {
            PropertyNameCaseInsensitive = true
        });
        var context = new TestLambdaContext();
        var response = await lambdaFunction.FunctionHandlerAsync(request, context);

        Assert.Equal(200, response.StatusCode);
        Assert.True(response.Headers.ContainsKey("Content-Type"));
    }
}