resource "aws_dynamodb_table" "table_ai_inbound" {
  name         = "table-ai-inbound"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }

  attribute {
    name = "Content"
    type = "S" # String type
  }

  attribute {
    name = "EventType"
    type = "S" # String type
  }

  attribute {
    name = "Status"
    type = "S" # String type
  }

  attribute {
    name = "Timestamp"
    type = "N" # Number type (for Unix timestamp or DateTime)
  }

  global_secondary_index {
    name            = "ContentIndex"
    hash_key        = "Content"
    projection_type = "ALL"
  }

  global_secondary_index {
    name            = "EventTypeIndex"
    hash_key        = "EventType"
    projection_type = "ALL"
  }

  global_secondary_index {
    name            = "StatusIndex"
    hash_key        = "Status"
    projection_type = "ALL"
  }

  global_secondary_index {
    name            = "TimestampIndex"
    hash_key        = "Timestamp"
    projection_type = "ALL"
  }

}