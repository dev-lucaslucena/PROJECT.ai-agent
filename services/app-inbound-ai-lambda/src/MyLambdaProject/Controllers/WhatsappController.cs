using Microsoft.AspNetCore.Mvc;
using MyLambdaProject.Models;
using MyLambdaProject.Services;
using System;
using System.Numerics;
using System.Threading.Tasks;

namespace MyLambdaProject.Controllers
{
    [Route("api/inbound-ai/[controller]")]
    [ApiController]
    public class WhatsappController : ControllerBase
    {
        private readonly ISqsService _sqsService;
        private readonly IDynamoDbService _dynamoDbService;
        private readonly ILogService<WhatsappController> _logService;

        public WhatsappController(ISqsService sqsService, IDynamoDbService dynamoDbService, ILogService<WhatsappController> logService)
        {
            _sqsService = sqsService;
            _dynamoDbService = dynamoDbService;
            _logService = logService;
        }

        [HttpGet()]
        public IActionResult Get([FromQuery(Name = "hub.challenge")] string challenge)
        {
            return Ok(challenge);
        }

        [HttpPost()]
        public async Task<IActionResult> Post([FromBody] WhatsappWebhookPayload payload)
        {
            _logService.LogInfo("Received POST request");

            foreach (var entry in payload.Entry!)
            {
                foreach (var change in entry.Changes!)
                {
                    var value = change.Value!;

                    if (value.Messages == null)
                    {
                        _logService.LogInfo("No messages to process");
                        return Ok();
                    }

                    _logService.LogInfo($"Processing {value.Messages.Count} messages");

                    foreach (var message in value.Messages)
                    {
                        var dbMessage = new Inbound
                        {
                            Id = Guid.NewGuid().ToString(),
                            Content = message?.Text?.Body!,
                            EventType = message?.Type!,
                            Timestamp = DateTimeOffset.FromUnixTimeSeconds(long.Parse(message?.Timestamp!)).ToUnixTimeMilliseconds(),
                            Status = "Inbound"
                        };

                        _logService.LogInfo($"Received {message?.Type} message: {message?.Text?.Body}");

                        try
                        {
                            await _sqsService.SendMessageAsync(message?.Text?.Body!);
                            await _dynamoDbService.SaveMessageAsync(dbMessage);
                            _logService.LogInfo($"Message processed and saved with ID: {dbMessage.Id}");
                        }
                        catch (Exception ex)
                        {
                            _logService.LogError($"Error processing message: {ex.Message}");
                        }
                    }
                }
            }

            _logService.LogInfo("Processed all messages, returning OK");
            return Ok();
        }
    }
}