using System.Threading.Tasks;

namespace MyLambdaProject.Services
{
    public interface ISqsService
    {
        Task SendMessageAsync(string message);
    }
}