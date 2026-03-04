terraform {
  backend "s3" {
    bucket         = "two-tier-terraform-state-winters-2026"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "two-tier-terraform-lock"
    encrypt        = true
  }
}

provider "aws" {
  region = "us-east-1"
}

module "network" {
  source   = "../../modules/network"
  vpc_cidr = "10.0.0.0/16"

  azs = [
    "us-east-1a",
    "us-east-1b"
  ]
}

module "ecs" {
  source = "../../modules/ecs"

  vpc_id            = module.network.vpc_id
  subnet_ids        = module.network.private_subnets
  public_subnet_ids = module.network.public_subnets
  security_group_id = module.network.app_sg_id
  image_url         = "nginx:latest"
}

