using System.Threading.Tasks;

namespace MyLambdaProject.Common
{
    public interface ISqsService
    {
        Task SendMessageAsync(string message);
    }
}