terraform {
  backend "s3" {
    bucket         = "two-tier-terraform-state-winters-2026"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "two-tier-terraform-lock"
    encrypt        = true
  }
}