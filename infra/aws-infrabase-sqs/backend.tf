terraform {
  backend "s3" {
    bucket         = "storage-terraform-state-bucket"
    key            = "global/aws-infrabase-sqs/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "global-terraform-locks"
  }
}