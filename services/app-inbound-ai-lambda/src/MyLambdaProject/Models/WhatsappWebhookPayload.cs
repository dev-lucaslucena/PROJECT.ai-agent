using System.Diagnostics.CodeAnalysis;
using System.Text.Json.Serialization;
using ThirdParty.Json.LitJson;

namespace MyLambdaProject.Models
{
    public class WhatsappWebhookPayload
    {
        [NotNull]
        public string? Object { get; init; }
        [NotNull]
        public List<Entry>? Entry { get; init; }
    }

    public class Entry
    {
        [NotNull]
        public string? Id { get; init; }
        [NotNull]
        public List<Change>? Changes { get; init; }
    }

    public class Change
    {
        [NotNull]
        public Value? Value { get; init; }
        [NotNull]
        public string? Field { get; init; }
    }

    public class Value
    {
        [NotNull]
        public string? MessagingProduct { get; init; }
        [NotNull]
        public Metadata? Metadata { get; init; }
        public List<Contact>? Contacts { get; init; }
        public List<MessageValue>? Messages { get; init; }
        public List<StatusValue>? Statuses { get; init; }
    }

    public class Metadata
    {
        [NotNull]
        public string? DisplayPhoneNumber { get; init; }
        [NotNull]
        public string? PhoneNumberId { get; init; }
    }

    public class Contact
    {
        public Profile? Profile { get; init; }
        [JsonPropertyName("wa_id")]
        public string? WaId { get; init; }
    }

    public class Profile
    {
        public string? Name { get; init; }
    }

    public class MessageValue
    {
        public string? Id { get; init; }
        public string? From { get; init; }
        public string? Timestamp { get; init; }
        public string? Type { get; init; }
        public Text? Text { get; init; }
        // Add other messageValue types as needed
    }

    public class Text
    {
        public string? Body { get; init; }
    }

    public class StatusValue
    {
        public string? Id { get; init; }
        public string? Status { get; init; }
        public string? Timestamp { get; init; }
        // Add other status fields as needed
    }
}