module "templates" {
    source = "../../templates"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
  backend "s3" {
    bucket = "terraform-backend-440546640008"
    key    = "aws_stuff/day_two_two_tier_application/terraform"
    region = "us-east-1"
    profile = "AdministratorAccess-440546640008"
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
  profile = "AdministratorAccess-440546640008"
}

output  key {
  value = join("/", slice(split("/", path.cwd), index(split("/", path.cwd), "aws_stuff"), length(split("/", path.cwd))))
}