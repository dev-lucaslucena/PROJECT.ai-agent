using OpenAI;
using OpenAI.Chat;
using System.Threading.Tasks;

namespace MyLambdaProject.Common
{
    public class OpenAiService : IOpenAiService
    {
        private readonly ChatClient _openAi;

        public OpenAiService(string model, string apiKey)
        {
            _openAi = new ChatClient(model, apiKey);
        }

        public async Task<string> GetCompletionAsync(string prompt)
        {
            ChatCompletion completion = await _openAi.CompleteChatAsync(prompt);

            return completion.Content[0].Text;
        }
    }
}