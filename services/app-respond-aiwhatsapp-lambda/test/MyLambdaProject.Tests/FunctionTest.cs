using Amazon.Lambda.Core;
using Amazon.Lambda.SNSEvents;
using AWS.Lambda.Powertools.Logging;
using Microsoft.Extensions.DependencyInjection;
using Moq;
using Moq.Protected;
using MyLambdaProject.Common;
using System.Collections.Generic;
using System.Net;
using System.Net.Http;
using System.Threading;
using System.Threading.Tasks;
using Xunit;

namespace MyLambdaProject.Tests
{
    public class FunctionTest
    {
        [Fact]
        public async Task TestFunctionHandler()
        {
        }
    }
}