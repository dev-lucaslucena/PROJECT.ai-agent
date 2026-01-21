resource "aws_dynamodb_table" "global-terraform-locks" {
  name = "global-terraform-locks"

  attribute {
    name = "LockID"
    type = "S"
  }

  hash_key = "LockID"
  
  billing_mode = "PAY_PER_REQUEST"
}