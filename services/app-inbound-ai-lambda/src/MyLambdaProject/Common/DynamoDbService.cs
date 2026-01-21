using Amazon.DynamoDBv2;
using Amazon.DynamoDBv2.DataModel;
using MyLambdaProject.Models;
using System.Threading.Tasks;

namespace MyLambdaProject.Services
{
    public class DynamoDbService : IDynamoDbService
    {
        private readonly IAmazonDynamoDB _dynamoDbClient;
        private readonly IDynamoDBContext _context;

        public DynamoDbService(IAmazonDynamoDB dynamoDbClient)
        {
            _dynamoDbClient = dynamoDbClient;
            _context = new DynamoDBContext(_dynamoDbClient);
        }

        public async Task SaveMessageAsync(Inbound message)
        {
            await _context.SaveAsync(message);
        }
    }
}