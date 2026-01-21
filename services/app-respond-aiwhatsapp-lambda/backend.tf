terraform {
  backend "s3" {
    bucket = "storage-terraform-state-bucket"
    key    = "global/app-respond-aiwhatsapp-lambda/terraform.tfstate"
    region = "us-east-1"   
    dynamodb_table = "global-terraform-locks"
  }
}