using Amazon.DynamoDBv2.DataModel;

namespace MyLambdaProject.Models
{
    [DynamoDBTable("table-ai-inbound")]
    public class Inbound
    {
        [DynamoDBHashKey("id")]
        public string Id { get; set; }
        [DynamoDBProperty]
        public string Content { get; set; }
        [DynamoDBProperty]
        public string EventType { get; set; }
        [DynamoDBProperty]
        public string Status { get; set; }
        [DynamoDBProperty]
        public long Timestamp { get; set; }
    }
}