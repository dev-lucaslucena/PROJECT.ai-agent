terraform {
  backend "s3" {
    bucket = "storage-terraform-state-bucket"
    key    = ""
    region = "us-east-1"   
    dynamodb_table = "global-terraform-locks"
  }
}