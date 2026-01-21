using MyLambdaProject.Models;
using System.Threading.Tasks;

namespace MyLambdaProject.Services
{
    public interface IDynamoDbService
    {
        Task SaveMessageAsync(Inbound message);
    }
}